class LostAlert < ActiveRecord::Base
  has_many :images, as: :imageable

  has_many :found_alerts
  belongs_to :user
end
