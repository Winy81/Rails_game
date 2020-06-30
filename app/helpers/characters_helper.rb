module CharactersHelper

  include Services::DateTransformer

  def life_length_counter(character)
    length = character.updated_at - character.created_at
    result(length)
  end

  private

  def result(seconds)
    hours = seconds / SECOND_IN_A_HOUR
    full_days = hours_to_full_days(hours)
    hours = rest_of_hours(hours)
    formated_time_layout(full_days,hours)
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

end
