class Character < ActiveRecord::Base

  belongs_to :user

  validates :name, length: { maximum: 25 }
  validates :name, :fed_state, :happiness, :activity_require_level, :status, presence: true
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
    current_age = self.age
    self.update_attributes(fed_state: fed_limit(current_fed_state -= 1).fed_level_min_setter,
                           activity_require_level: activity_limit(current_activity_require_level += 2).activity_level_max_setter,
                           happiness: happiness_limit(current_happiness -= 1).happiness_level_min_setter,
                           age: current_age + 1)
  end

  def activity_require_level_decrease_with(decreased_with)
    decreased_value = self.activity_require_level.to_i + decreased_with
    accepted_decreased_value = activity_limit(decreased_value).activity_level_min_setter
    self.update_attributes(activity_require_level:accepted_decreased_value)
  end

  def activity_require_level_increased_with(increased_with)
    increased_value = self.activity_require_level.to_i + increased_with
    accepted_increased_value = activity_limit(increased_value).activity_level_max_setter
    self.update_attributes(activity_require_level:accepted_increased_value)
  end

  def fed_state_increase_with(increased_with)
    increased_value = self.fed_state.to_i + increased_with
    accepted_increased_value = fed_limit(increased_value).fed_level_max_setter
    self.update_attributes(fed_state:accepted_increased_value)
  end

  def happiness_decreased_with(decreased_with)
    decreased_value = self.happiness.to_i + decreased_with
    accepted_decreased_value = happiness_limit(decreased_value).happiness_level_min_setter
    self.update_attributes(happiness:accepted_decreased_value)
  end

  def happiness_increase_with(increased_with)
    increased_value = self.happiness.to_i + increased_with
    accepted_increased_value = happiness_limit(increased_value).happiness_level_max_setter
    self.update_attributes(happiness:accepted_increased_value)
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
