module CharactersServices
  module Events
    module RandomEvents
      class WorldHuntingEvent

        ID = 2
        FED_STATE_FOR_REACH = 25%
        ACTIVITY_LEVEL = 50%
        DESCRIPTION = "You were part of a global hunting event. Lost #{ACTIVITY_LEVEL} your Activity level but reached extra #{FED_STATE_FOR_REACH} for your Fed State"
        EVENT_NAME = self.to_s.split("::").last

        def process
          characters = Character.active_living_characters
          characters.each do |character|
            #character
          end
          event_recording
        end

        private

        def event_recording
          CharactersServices::Events::EventRecorder.new(DESCRIPTION).process
        end
      end
    end
  end
end