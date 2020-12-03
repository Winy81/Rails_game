module Jobs
  class CharacterSpecialEventRunner

    CHRISTMAS_DATE = "12-24--06-00"
    NEW_YEARS_EVE_DATE = "01-01--00-00"
    HALLOWEEN_EVENT = "10-31--20-00"

    def perform
      current_date_time
      christmas_event if current_date_time == CHRISTMAS_DATE
      new_year_event if current_date_time == NEW_YEARS_EVE_DATE
      halloween_event if current_date_time == HALLOWEEN_EVENT
      time_pass_event
    end

    def time_pass_event
      CharactersServices::Events::SpecialEvents::CharacterTimePassManager.new().process
    end

    def christmas_event
      true
    end

    def new_year_event
      true
    end

    def halloween_event
      true
    end

    def current_date_time
      date_time = Time.now
      formated_date_time = date_time.strftime("%_m-%-d--%H-%M")
      formated_date_time
    end

  end
end