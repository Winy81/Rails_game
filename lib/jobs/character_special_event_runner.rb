module Jobs
  class CharacterSpecialEventRunner

    def perform
      CharactersServices::Events::SpecialEvents::CharacterTimePassManager.new().process
    end

  end
end