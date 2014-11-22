class FoundAlert < ActiveRecord::Base
  has_many :images, as: :imageable

  belongs_to :lost_alert
  belongs_to :user
end
