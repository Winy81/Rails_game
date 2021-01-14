require 'spec_helper'

describe CharactersServices::Events::SpecialEvents::CharacterTimePassManager do

  let(:id) { CharactersServices::Events::SpecialEvents::CharacterTimePassManager::ID }
  let(:description) { CharactersServices::Events::SpecialEvents::CharacterTimePassManager::DESCRIPTION }
  let(:event_name) { described_class.to_s.split("::").last }

  context 'When the event has been called' do

    context 'When the character updated and still alive' do

      let(:character) { double('Character', id:1, user_id: 1, fed_state:10) }
      let(:updated_character) { double('Character') }
      let(:characters) { [ character ] }

      it 'should update the character successfully ' do

        expect(Character).to receive(:active_living_characters).and_return(characters)
        allow(character).to receive(:simulated_time_passed_updated).and_return(updated_character)
        expect(character).to receive(:reload).and_return(updated_character)
        expect(character).to receive(:fed_state).and_return(9)

        expect(Event).to receive(:create).with(event_id:id,event_name:event_name,description:description)

        CharactersServices::Events::SpecialEvents::CharacterTimePassManager.new().process

      end
    end

    context 'When the character updated and dying' do

      let(:character) { double('Character', id:1, user_id:1 , fed_state:1) }
      let(:updated_character) { double('Character') }
      let(:characters) { [ character ] }
      let(:user_of_character) { double('User', id:1, has_character: true) }

      it 'should update the character successfully ' do

        expect(Character).to receive(:active_living_characters).and_return(characters)
        allow(character).to receive(:simulated_time_passed_updated).and_return(updated_character)
        expect(character).to receive(:reload).and_return(updated_character)
        expect(character).to receive(:fed_state).and_return(0)
        expect(character).to receive(:character_is_dying)
        expect(character).to receive(:user).and_return(user_of_character)
        expect(user_of_character).to receive(:user_loosing_character)

        expect(Event).to receive(:create).with(event_id:id,event_name:event_name,description:description)

        CharactersServices::Events::SpecialEvents::CharacterTimePassManager.new().process

      end
    end

  end
end