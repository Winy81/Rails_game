class Character < ActiveRecord::Base

  belongs_to :user

  def self.age_order_alive_filter
    order(:age => :desc).where(status:"alive")
  end

end
