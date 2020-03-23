class Character < ActiveRecord::Base

  belongs_to :user

  def self.age_order_filter
    order(:age => :desc)
  end

end
