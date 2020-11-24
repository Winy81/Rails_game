module Jobs
  class CharacterEventRunner

    def perform
      random_event_caller(random_event_selector)
    end

    private

    def random_event_selector
      rand(1..1000)
    end

    def random_event_caller(identifier)
      if (1..100).include?(identifier)
        CharactersServices::Events::RandomEvents::CharityEvent.new().process
      end
    end

  end
end