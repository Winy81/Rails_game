module CharactersServices
  class RequestPathRecogniser

    FEEDING_PATH = "feeding"
    ACTIVITY_PATH = "activity"
    PLAYING_PATH = "playing"

    def initialize(params)
      @params = params
    end

    def request_path_recognise_helper
      if @params == 'from_feeding_process'
        FEEDING_PATH
      elsif @params == 'from_activity_process'
        ACTIVITY_PATH
      elsif @params == 'from_playing_process'
        PLAYING_PATH
      end
    end

  end
end