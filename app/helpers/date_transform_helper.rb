module DateTransformHelper

  HOURS_IN_A_DAY = 24
  SECOND_IN_A_HOUR = 3600

  def hours_to_full_days(hours)
    (hours / HOURS_IN_A_DAY).to_i
  end

  def rest_of_hours(hours)
    (hours % HOURS_IN_A_DAY).to_i
  end

  def date_view_optimizer(date)
    date.strftime('%Y:%m:%d')
  end

end