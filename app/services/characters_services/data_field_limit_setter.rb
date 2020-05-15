module CharactersServices
  class DataFieldLimitSetter

    FEED_LIMIT_MAX = 100
    ACTIVITY_LIMIT_MIN = 0

    def initialize(level)
      @level = level
    end

    def fed_level_max_setter
      @level > 100 ? @level = FEED_LIMIT_MAX : @level
    end

    def activity_level_min_setter
      @level < 0 ? @level = ACTIVITY_LIMIT_MIN : @level
    end

  end
end