class DataFieldLimitSetter

  FEED_LIMIT_MAX = 100

  def initialize(level)
    @level = level
  end

  def fed_level_max_setter
    @level > 100 ? @level = FEED_LIMIT_MAX : @level
  end

end