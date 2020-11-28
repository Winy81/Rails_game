module CharactersServices
  module Events
    module RandomEvents
      class CharityEvent

        ID = 1
        GOLD_FOR_LOST = 1
        DESCRIPTION = "You payed #{GOLD_FOR_LOST} gold for the destroyed neighbour village"
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
          current_amount - GOLD_FOR_LOST
        end

        def current_budget(character)
          character.user.budget
        end

      end
    end
  end
end