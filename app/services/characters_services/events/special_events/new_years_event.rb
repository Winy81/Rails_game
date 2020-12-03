module CharactersServices
  module Events
    module SpecialEvents
      class NewYearsEvent < EventRecorder

        ID = 102
        GOLD_FOR_REACH = 20
        INCREASED_HAPPINESS_WITH = 25
        INCREASED_ACTIVITY_LEVEL_WITH = 25
        DESCRIPTION = "New year, new hope! You have reached: #{GOLD_FOR_REACH} Gold, #{INCREASED_HAPPINESS_WITH} Happiness Point, #{INCREASED_ACTIVITY_LEVEL_WITH} Activity Points! Happy New Year!"
        EVENT_NAME = self.to_s.split("::").last

        def process
          characters = Character.active_living_characters
          characters.each do |character|
            character.happiness_increase_with(INCREASED_HAPPINESS_WITH)
            character.activity_require_level_increased_with(INCREASED_ACTIVITY_LEVEL_WITH)
            character.user.set_budget(updated_budget(character))
          end
          event_recording(ID,EVENT_NAME,DESCRIPTION)
        end

        private

        def updated_budget(character)
          current_amount = current_budget(character)
          current_amount + GOLD_FOR_REACH
        end

        def current_budget(character)
          character.user.budget
        end

      end
    end
  end
end