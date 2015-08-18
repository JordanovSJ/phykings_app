class User < ActiveRecord::Base
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
		cost=5
		if self.gold >= cost && self.relation_of(problem).present? && !self.relation_of(problem).can_see_answer
			ActiveRecord::Base.transaction do
				present_gold=Bank.access.present_gold + cost
				Bank.access.update_attributes!(present_gold: present_gold)
				user_gold=self.gold - cost
				self.update_attributes!(gold: user_gold)
				self.relation_of(problem).update_attributes!(can_see_answer: true)	
			end
		end
	end
	
	#badly written comments again:
	#unlocks the solutions of the problem if there is a relation between the user and the problem
	#the user pays the bank 10 gold for that
	def unlock_solutions_of(problem)
		cost=10
		if self.gold >= cost && self.relation_of(problem).present? && !self.relation_of(problem).can_see_solution
			ActiveRecord::Base.transaction do
				present_gold=Bank.access.present_gold + cost
				Bank.access.update_attributes!(present_gold: present_gold)
				user_gold=self.gold - cost
				self.update_attributes!(gold: user_gold)
				self.relation_of(problem).update_attributes!(can_see_solution: true)	
			end
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
  
end
