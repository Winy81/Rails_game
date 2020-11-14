module Jobs
  class CharacterDetailsManagerRunner

    @queue = :manager

    def perform
      CharactersServices::CharacterDetailsManager.hold
    end

  end
end