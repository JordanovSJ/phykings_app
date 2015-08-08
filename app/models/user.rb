class User < ActiveRecord::Base
	has_many :uploaded_problems, class_name: 'Problem', 
															:foreign_key => 'creator_id'
	
	has_many :relations,:foreign_key => 'solver_id',
						:dependent => :destroy
						
	has_many :solved_problems, :through => :relations #class_name: 'User',
						
						
 
 
 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
         
  # Obvious validations
  validates :first_name, presence: true, length: {maximum: 20}
  validates :last_name, presence: true, length: {maximum: 20}
  validates :age, presence: true, numericality: { only_integer: true,
									greater_than_or_equal_to: 1,
									less_than_or_equal_to: 100 }
	validates :country, presence: true
  
  # Code initially taken from Devise Omniauth documentation, but changed.
  # Changed first_or_create to first_or_initialize, so that we can use
  # user.skip_confirmation! before the user is saved and in this way
  # skip the email confirmation step for a user that logs in with Facebook.
  # Also, spent quite a lot of time trying to figure out the correct auth
  # fields from the Facebook callback. Had to add scope in config.omniauth
  # in config/initializers/devise.rb with the names of the appropriate fields.
  def self.from_omniauth(auth)
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
  
end