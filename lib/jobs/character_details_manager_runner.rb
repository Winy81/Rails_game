module Jobs
  class CharacterDetailsManagerRunner

    #@queue = :manager

    def perform
      CharactersServices::Events::CharacterTimePassManager.new().process
    end

  end
end