module CharactersServices
  module Events
    module SpecialEvents
      class ChristmasEvent < EventRecorder

        ID = 101
        GOLD_FOR_REACH = 100
        DESCRIPTION = "You have a christmas gift with #{GOLD_FOR_REACH} gold in it! Merry Christmas!"
        EVENT_NAME = self.to_s.split("::").last

        def process
          characters = Character.active_living_characters
          characters.each do |character|
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