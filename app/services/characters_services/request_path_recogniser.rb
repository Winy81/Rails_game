module CharactersServices
  class RequestPathRecogniser

    def initialize(params)
      @params = params
    end

    def request_path_recognise_helper
      if @params == 'from_feeding'
        "feeding"
      elsif @params == 'from_activity'
        "activity"
      end
    end

  end
end