class Problem < ActiveRecord::Base
	validates :content, presence: true, length: { maximum: 3000 }
  validates :title, presence: true, length: { maximum: 100 }
  default_scope -> { order(created_at: :desc) }


end
