module CharactersHelper

  def life_length_counter(character)
    length = character.updated_at - character.created_at
    time_converter(length)
  end

  private

  def time_converter(seconds)
    hours = seconds / 3600
    full_days = hours_to_full_days(hours)
    hours = rest_of_hours(hours)
    result = "#{full_days} Days and #{hours} Hours"
    result
  end

  def hours_to_full_days(hours)
    full_days = (hours / 24).to_i
    full_days
  end

  def rest_of_hours(hours)
    full_hours = (hours % 24).to_i
    full_hours
  end

end
