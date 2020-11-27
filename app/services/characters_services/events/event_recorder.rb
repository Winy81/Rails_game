module CharactersServices
  module Events
    class EventRecorder

      def initialize(description)
        @description = description
      end

      def process
        Event.create(description:@description)
      end

    end
  end
end