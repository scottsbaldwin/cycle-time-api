class Subscription < ActiveRecord::Base
  validates :model_id, :description, :callback_url, presence: true
  validates :webhook_id, uniqueness: true
end
