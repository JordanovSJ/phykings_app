 
class User < ActiveRecord::Base
	include TransactionsHelper

	has_many :uploaded_problems, class_name: 'Problem', 
															:foreign_key => 'creator_id'
	
	#this has_many association is responsible for attempted, 
	#solved and problems provided with solutions
	has_many :user_problem_relations,:foreign_key => 'viewer_id' #,:dependent => :destroy						
	has_many :seen_problems, :through => :user_problem_relations 					
	has_many :solutions, :through => :user_problem_relations 
	has_many :notifications
						
	#methods
	
	#return the solution of problem submitted by the user, if there is no such solutions, returns nil
	def solution_of(problem)
		if self.seen_problems.include?(problem)
			return self.user_problem_relations.find_by(seen_problem_id: problem.id).solution
		end
	end
	
	#returns the relation between user and problem 
	def relation_of(problem)
		if self.seen_problems.include?(problem)
			return self.user_problem_relations.find_by(seen_problem_id: problem.id)
		end
	end



	
	#bank methods
	
	#badly written comments:
	#unlocks the answer of the problem if there is a relation between the user and the problem
	#the user pays the bank 5 gold for that
	def unlock_answer_of(problem)
		cost=COST_TO_UNLOCK_ANSWER
		if self.gold >= cost && self.relation_of(problem).present? && !self.relation_of(problem).can_see_answer
			if unlock_answer_transaction(cost, problem)
				if problem.creator.present?
					sum_to_pay=(0.9*cost).to_i
					transaction_bank_to_user(sum_to_pay, problem.creator)
				end
			end
		end
	end
	
	#its used in unlock_answer_of
	def unlock_answer_transaction(cost, problem)
		ActiveRecord::Base.transaction do
			transaction_user_to_bank(cost,self)
			self.relation_of(problem).update_attributes!(can_see_answer: true)	
			true
		end
	end
	
	#badly written comments again:
	#unlocks the solutions of the problem if there is a relation between the user and the problem
	#the user pays the bank 10 gold for that
	def unlock_solutions_of(problem)
		cost=COST_TO_UNLOCK_SOLUTIONS
		if self.gold >= cost && self.relation_of(problem).present? && !self.relation_of(problem).can_see_solution	
			if unlock_solution_transaction(cost, problem)			
				#send gold to the solvers of the problem
				solutions=problem.solutions
				number_solvers=solutions.count				
				if number_solvers > 0
					if number_solvers > 10
						# the ten solutions with highest voting
						paid_solutions=solutions.sort_by{ |s| (s.upvotes - s.downvotes)}.reverse[0..9] 
						sum_to_pay=((0.9*cost)/10).to_i
						paid_solutions.each do |ps|
							if ps.user.present?
								transaction_bank_to_user(sum_to_pay, ps.user)
							end
						end
					else					
						sum_to_pay=((0.9*cost) / number_solvers).to_i
						#the bank lose gold												
						solutions.each do |ps|
							if ps.user.present?
								transaction_bank_to_user(sum_to_pay, ps.user)
							end
						end				
					end
				end
			end
		end
	end
	
	def unlock_solution_transaction(cost, problem)
		ActiveRecord::Base.transaction do
			transaction_user_to_bank(cost,self)
			self.relation_of(problem).update_attributes!(can_see_solution: true)	
			true
		end
	end
	
	
#ALexndar.sa6o 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]
         
  # Obvious validations
  validates :first_name, presence: true, length: {maximum: 20}
  validates :last_name, presence: true, length: {maximum: 20}
  validates :age, presence: true, numericality: { only_integer: true,
									greater_than_or_equal_to: 1,
									less_than_or_equal_to: 100 }
	validates :country, presence: true
	
	#not so obvious one, but trust me
  validates :gold, :numericality => { :only_integer => true, :greater_than => -1}
  	
  # Code initially taken from Devise Omniauth documentation, but changed.
  # Changed first_or_create to first_or_initialize, so that we can use
  # user.skip_confirmation! before the user is saved and in this way
  # skip the email confirmation step for a user that logs in with Facebook.
  # Also, spent quite a lot of time trying to figure out the correct auth
  # fields from the Facebook callback. Had to add scope in config.omniauth
  # in config/initializers/devise.rb with the names of the appropriate fields.
  def self.from_omniauth_facebook(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
			user.email = auth.info.email # fill the email field
			user.password = Devise.friendly_token[0,20] # we don't care about the password
			user.first_name = auth.info.first_name   # fill the first_name
			user.last_name = auth.info.last_name   # fill the last_name
			user.country = auth.extra.raw_info.locale # NOTE: this is not exactly the country!
			user.age = Integer(auth.extra.raw_info.age_range.min[1]) # Finally found an age estimate
			user.image = auth.info.image # fill the link to the profile image
			user.skip_confirmation! # a key step to allow direct log in without confirmation email
			user.save! # save the user in the database
		end
	end
	
	# Method to extract user profile information from Google account info.
	def self.from_omniauth_google(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
			user.email = auth.info.email # fill the email field
			user.password = Devise.friendly_token[0,20] # we don't care about the password
			user.first_name = auth.info.first_name   # fill the first_name
			user.last_name = auth.info.last_name   # fill the last_name
			user.country = auth.extra.raw_info.locale # NOTE: this is not exactly the country!
			user.age = 100 # Finally found an age estimate
			user.image = auth.info.image # fill the link to the profile image
			user.skip_confirmation! # a key step to allow direct log in without confirmation email
			user.save! # save the user in the database
		end
	end
  
  private
  
  def send_gold_to_solvers(problem,cost)
		#send gold to the solvers of the problem
		number_solvers=problem.solutions.count
		solutions=problem.solutions
		if number_solvers > 0
			if number_solvers > 10
				#the bank lose gold
				Bank.access.increment(:present_gold, - (0.9*cost).to_i).save!
				# the ten solutions with highest voting
				paid_solutions=solutions.sort_by{ |s| (s.upvotes - s.downvotes)}.reverse[0..9] 
				sum_to_pay=((0.9*cost)/10).to_i
				paid_solutions.each do |ps|
					#the new gold of the solver
					ps.user.increment(:gold, sum_to_pay).save!
				end
			else					
				sum_to_pay=((0.9*cost) / number_solvers).to_i
				#the bank lose gold						
				Bank.access.increment(:present_gold, - sum_to_pay * number_solvers).save!
				solutions.each do |ps|
					#the new gold of the solver
					ps.user.increment(:gold, sum_to_pay).save!
				end
			end
		end
  end
  
end
