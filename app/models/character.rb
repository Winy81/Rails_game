class Character < ActiveRecord::Base

  belongs_to :user

  def self.age_order_filter
    order(:age => :desc)
  end

  def self.age_order_alive_filter
    order(:age => :desc).where(status:"alive")
  end

  #unused
  def self.current_users_character(user)
    where.not(user_id:user.id)
  end

end
