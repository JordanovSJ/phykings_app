class Notification < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :message, presence: true
  
  default_scope -> { order(created_at: :desc) }
end
