module Jobs
  class CharacterDetailsManagerRunner < ResqueJob
    @queue = :manager

    def perform
      CharacterDetailsManager.hold
    end

  end
end