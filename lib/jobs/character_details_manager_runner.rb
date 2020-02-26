module Jobs
  class CharacterDetailsManagerRunner
    @queue = :manager

    def perform
      CharacterDetailsManager.hold
    end

  end
end