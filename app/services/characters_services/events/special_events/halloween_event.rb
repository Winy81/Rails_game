module CharactersServices
  module Events
    module SpecialEvents
      class HalloweenEvent < EventRecorder

        ID = 103
        INCREASED_FED_STATE_WITH = 25
        DECREASED_HAPPINESS_WITH = -5
        DESCRIPTION = "Happy - Sad day this Halloween. You reached #{INCREASED_FED_STATE_WITH} Fed Points but lost #{DECREASED_HAPPINESS_WITH} Happiness on the end"
        EVENT_NAME = self.to_s.split("::").last

        def process
          characters = Character.active_living_characters
          characters.each do |character|
            character.fed_state_increase_with(INCREASED_FED_STATE_WITH)
            character.happiness_decreased_with(DECREASED_HAPPINESS_WITH)
          end
          event_recording(ID,EVENT_NAME,DESCRIPTION)
        end

      end
    end
  end
end