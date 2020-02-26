class CharacterDetailsManager

  def self.hold
    data = Character.all
    data.each do |details|
      details.update_attributes(fed_state: details.fed_state -=1)
    end
  end

end