module Jobs
  class CharacterEventRunner

    EVENT_1 = CharactersServices::Events::RandomEvents::CharityEvent
    EVENT_2 = CharactersServices::Events::RandomEvents::WorldHuntingEvent
    EVENT_3 = CharactersServices::Events::RandomEvents::GoldRainEvent

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
      elsif (21..30).include?(identifier)
        EVENT_3.new().process
      end
    end

  end
end