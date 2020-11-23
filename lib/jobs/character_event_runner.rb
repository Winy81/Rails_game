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
      identifier
    end

  end
end