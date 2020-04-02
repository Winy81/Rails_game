module CharactersServices
  class RequestPathRecogniser

    FEEDING_PATH = "feeding"
    ACTIVITY_PATH = "activity"

    def initialize(params)
      @params = params
    end

    def request_path_recognise_helper
      if @params == 'from_feeding_process'
        FEEDING_PATH
      elsif @params == 'from_activity_process'
        ACTIVITY_PATH
      end
    end

  end
end