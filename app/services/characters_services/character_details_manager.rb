module CharactersServices
  class CharacterDetailsManager

    def process
      characters = Character.where(status:'alive',hibernated:false, manualy_hibernated:false)
      characters.each do |character|
        character.update_attributes(fed_state: character.fed_state -= 1,
                                    activity_require_level: character.activity_require_level += 2,
                                    happiness: character.happiness -= 1)
        character.reload
        if character.fed_state <= 0
          character.update_attributes(status:'dead', died_on: Time.now)
          character.user.update_attributes(has_character:false)
        end
      end
    end
  end
end