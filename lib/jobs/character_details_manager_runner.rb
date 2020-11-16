module Jobs
  class CharacterDetailsManagerRunner

    #@queue = :manager

    def perform
      CharactersServices::CharacterDetailsManager.new().process
    end

  end
end