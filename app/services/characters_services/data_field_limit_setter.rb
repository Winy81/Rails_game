module CharactersServices
  class DataFieldLimitSetter

    module CharacterValuesLimit
      FED_LIMIT_MIN, ACTIVITY_LIMIT_MIN, HAPPINESS_LIMIT_MIN = 0, 0, 0
      FEED_LIMIT_MAX, ACTIVITY_LIMIT_MAX, HAPPINESS_LIMIT_MAX = 100, 100, 100
    end

    def initialize(level)
      @level = level
    end

    def fed_level_max_setter
      @level > 100 ? @level = CharacterValuesLimit::FEED_LIMIT_MAX : @level
    end

    def fed_level_min_setter
      @level < 0 ? @level = CharacterValuesLimit::FED_LIMIT_MIN : @level
    end

    def activity_level_min_setter
      @level < 0 ? @level = CharacterValuesLimit::ACTIVITY_LIMIT_MIN : @level
    end

    def activity_level_max_setter
      @level > 100 ? @level = CharacterValuesLimit::ACTIVITY_LIMIT_MAX : @level
    end

    def happiness_level_max_setter
      @level > 100 ? @level = CharacterValuesLimit::HAPPINESS_LIMIT_MAX : @level
    end

    def happiness_level_min_setter
      @level < 0 ? @level = CharacterValuesLimit::FED_LIMIT_MIN : @level
    end

  end
end