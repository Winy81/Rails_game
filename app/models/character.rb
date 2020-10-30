class Character < ActiveRecord::Base

  belongs_to :user

  validates :name, length: { maximum: 25 }
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :user_id, presence: true

  def self.age_order_filter
    order(:age => :desc)
  end

  def self.age_order_alive_filter
    order(:age => :desc).where(status:"alive")
  end

  def self.character_in_asc_id_order
    order(:id => :asc)
  end


  def self.characters_history_order_logic
    order(:status => :asc, :id => :desc)
  end

  def self.limited_desc_ordered_characters
    all.order(:age => :desc).limit(10)
  end

  #unused
  def self.current_users_character(user)
    where.not(user_id:user.id)
  end

end
