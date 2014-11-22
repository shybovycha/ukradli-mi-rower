class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :bikes
  has_many :lost_alerts
  has_many :found_alerts

  before_create :generate_api_key

  private

  def generate_api_key
    existing_keys = User.select(:api_key)

    begin
      self.api_key = SecureRandom.hex
    end while existing_keys.include?(self.api_key)
  end
end
