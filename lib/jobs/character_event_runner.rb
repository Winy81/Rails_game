module Jobs
  class CharacterEventRunner

    EVENT_ID_1 = CharactersServices::Events::RandomEvents::CharityEvent

    def perform
      random_event_caller(random_event_selector)
    end

    private

    def random_event_selector
      rand(1..1000)
    end

    def random_event_caller(identifier)
      if (1..10).include?(identifier)
        EVENT_ID_1.new().process
      end
    end

  end
end