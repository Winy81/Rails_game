class Wallet < ActiveRecord::Base

  belongs_to :user

  validates :amount, presence: true
  validates :amount, numericality: { only_integer: true }
  validates :user_id, presence: true

end
