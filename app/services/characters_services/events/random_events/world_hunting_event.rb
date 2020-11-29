module CharactersServices
  module Events
    module RandomEvents
      class WorldHuntingEvent < EventRecorder

        ID = 2
        INCREASED_FED_STATE_WITH = 25
        INCREASED_HAPPINESS_WITH = 25
        REDUCED_ACTIVITY_LEVEL_WITH = -40
        DESCRIPTION = "You were part of a global hunting event. Lost #{-1 * REDUCED_ACTIVITY_LEVEL_WITH} of your Activity level but reached extra #{INCREASED_FED_STATE_WITH} for your Fed State"
        EVENT_NAME = self.to_s.split("::").last

        def process
          characters = Character.active_living_characters
          characters.each do |character|
            character.activity_require_level_decrease(character.activity_require_level, REDUCED_ACTIVITY_LEVEL_WITH)
            character.fed_state_increase(character.fed_state, INCREASED_FED_STATE_WITH)
            character.happiness_increase(character.happiness, INCREASED_HAPPINESS_WITH)
          end
          event_recording(ID,EVENT_NAME,DESCRIPTION)
        end

      end
    end
  end
end