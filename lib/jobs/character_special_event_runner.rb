module Jobs
  class CharacterSpecialEventRunner

    module SpecialEventList
      EVENT_1 = CharactersServices::Events::SpecialEvents::CharacterTimePassManager
      EVENT_2 = CharactersServices::Events::SpecialEvents::ChristmasEvent
      EVENT_3 = CharactersServices::Events::SpecialEvents::NewYearsEvent
      EVENT_4 = CharactersServices::Events::SpecialEvents::HalloweenEvent
    end

    module DatesOfSpecialEvents
      CHRISTMAS_DATE = "12-24--06-00"
      NEW_YEARS_EVE_DATE = "1-1--00-00"
      HALLOWEEN_EVENT = "10-31--20-00"
    end

    def perform
      current_date_time
      christmas_event if current_date_time == DatesOfSpecialEvents::CHRISTMAS_DATE
      new_year_event if current_date_time == DatesOfSpecialEvents::NEW_YEARS_EVE_DATE
      halloween_event if current_date_time == DatesOfSpecialEvents::HALLOWEEN_EVENT
      time_pass_event
    end

    private

    def time_pass_event
      SpecialEventList::EVENT_1.new().process
    end

    def christmas_event
      SpecialEventList::EVENT_2.new().process
    end

    def new_year_event
      SpecialEventList::EVENT_3.new().process
    end

    def halloween_event
      SpecialEventList::EVENT_4.new().process
    end

    def current_date_time
      date_time = Time.now
      formated_date_time = date_time.strftime("%_m-%-d--%H-%M").gsub(/\s+/, "")
      formated_date_time
    end

  end
end