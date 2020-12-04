module CharactersServices
  module Events
    module SpecialEvents
      class CharacterTimePassManager < EventRecorder

        ID = 100
        DESCRIPTION = "An another hour has passed"
        EVENT_NAME = self.to_s.split("::").last

        def process
          characters = Character.active_living_characters
          characters.each do |character|
            time_pass_process(character)
            character.reload
            if character.fed_state <= 0
              dying_process(character)
            end
          end
          event_recording(ID,EVENT_NAME,DESCRIPTION)
        end

        private

        def time_pass_process(character)
          character.simulated_time_passed_updated
        end

        def dying_process(character)
          character.character_is_dying
          character.user.user_loosing_character
        end

      end
    end
  end
end