module CharactersServices
  module Events
    class EventRecorder

      def initialize(id,name,description)
        @id = id
        @name = name
        @description = description
      end

      def process
        Event.create(event_id:@id,event_name:@name,description:@description)
      end

    end
  end
end