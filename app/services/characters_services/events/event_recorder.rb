module CharactersServices
  module Events
    class EventRecorder

      def event_recording(id,event_name,description)
        Event.create(event_id:id,event_name:event_name,description:description)
      end

    end
  end
end