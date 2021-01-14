module CharactersServices
  module Events
    module RandomEvents
      class WorldBossEvent < EventRecorder

        ID = 4
        REDUCED_ACTIVITY_LEVEL_WITH = -50
        GOLD_FOR_REACH = 200
        DESCRIPTION = "You were fighting against a world boss! You have lost #{REDUCED_ACTIVITY_LEVEL_WITH} activity points but you got a massive reward, #{GOLD_FOR_REACH} gold"
        EVENT_NAME = self.to_s.split("::").last

        def process
          characters = Character.active_living_characters
          characters.each do |character|
            character.user.set_budget(updated_budget(character))
            character.activity_require_level_decrease_with(REDUCED_ACTIVITY_LEVEL_WITH)
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