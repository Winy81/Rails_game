module CharactersServices
  class CharacterDetailsManager

    def self.hold
      data = Character.where(status:'alive')
      data.each do |details|
        details.update_attributes(fed_state: details.fed_state -= 1)
      end
    end

  end
end