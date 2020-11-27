module Jobs
  class CharacterEventRunner

    EVENT_1 = CharactersServices::Events::RandomEvents::CharityEvent
    EVENT_2 = CharactersServices::Events::RandomEvents::WorldHuntingEvent

    def perform
      random_event_caller(random_event_selector)
    end

    private

    def random_event_selector
      rand(1..1000)
    end

    def random_event_caller(identifier)
      if (1..10).include?(identifier)
        EVENT_1.new().process
      elsif (11..20).include?(identifier)
        EVENT_2.new().process
      end
    end

  end
end