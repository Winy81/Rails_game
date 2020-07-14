module CharactersHelper

  include Services::DateTransformer

  def life_length_counter(character)
    length = character.updated_at - character.created_at
    result(length)
  end

  def params_builder_of_feeding(character,wallet,fed_points,cost,happiness_points,activity_points,source)
    params_of_fed_state = character.fed_state + fed_points
    params_of_happiness = character.happiness + happiness_points
    params_of_activity = character.activity_require_level + activity_points
    params_of_amount = wallet + cost

    {fed_state: params_of_fed_state,
     amount: params_of_amount,
     happiness: params_of_happiness,
     activity_require_level: params_of_activity,
     extra: source}
  end

  def params_builder_of_activity(character,wallet,fed_points,cost,happiness_points,activity_points,source)
    params_of_fed_state = character.fed_state + fed_points
    params_of_happiness = character.happiness + happiness_points
    params_of_activity = character.activity_require_level + activity_points
    params_of_amount = wallet + cost

    {fed_state: params_of_fed_state,
     amount: params_of_amount,
     happiness: params_of_happiness,
     activity_require_level: params_of_activity,
     extra: source}
  end

  def params_builder_of_playing(character,wallet,fed_points,cost,happiness_points,activity_points,source)
    params_of_fed_state = character.fed_state + fed_points
    params_of_happiness = character.happiness + happiness_points
    params_of_activity = character.activity_require_level + activity_points
    params_of_amount = wallet + cost

    {fed_state: params_of_fed_state,
     amount: params_of_amount,
     happiness: params_of_happiness,
     activity_require_level: params_of_activity,
     extra: source}
  end

  def params_builder_of_feeding_process(fed_state,amount,activity_state,happiness_state,source)
    {fed_state: fed_state,
     amount: amount,
     activity_require_level: activity_state,
     happiness: happiness_state,
     extra: source }
  end

  def params_builder_of_playing_process(fed_state,amount,activity_state,happiness_state,source)
    {fed_state: fed_state,
     amount: amount,
     activity_require_level: activity_state,
     happiness: happiness_state,
     extra: source }
  end

  def formated_time_layout(full_days,hours)
    "#{full_days} Days and #{hours} Hours"
  end

  def amount_of_cost_on_actions(amount)
    "Going to Cost: #{amount} Gold"
  end

  def amount_of_earn_on_actions(amount)
    "Going to Get: #{amount} Gold"
  end

  private

  def result(seconds)
    hours = seconds / SECOND_IN_A_HOUR
    full_days = hours_to_full_days(hours)
    hours = rest_of_hours(hours)
    formated_time_layout(full_days,hours)
  end

end
