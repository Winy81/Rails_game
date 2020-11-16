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

  def owner_of_character
    self.user.name
  end

  def self.active_living_characters
    where(status:'alive',hibernated:false, manualy_hibernated:false)
  end

  def character_is_dying
    self.update_attributes(status:'dead',
                           died_on: Time.now)
  end

  def simulated_time_passed_updated
    current_fed_state = self.fed_state
    current_activity_require_level = self.activity_require_level
    current_happiness = self.happiness
    self.update_attributes(fed_state: fed_limit(current_fed_state -= 1).fed_level_min_setter,
                           activity_require_level: activity_limit(current_activity_require_level += 2).activity_level_max_setter,
                           happiness: happiness_limit(current_happiness -= 1).happiness_level_min_setter)
  end

  private

  def fed_limit(points)
    CharactersServices::DataFieldLimitSetter.new(points)
  end

  def activity_limit(points)
    CharactersServices::DataFieldLimitSetter.new(points)
  end

  def happiness_limit(points)
    CharactersServices::DataFieldLimitSetter.new(points)
  end

end
