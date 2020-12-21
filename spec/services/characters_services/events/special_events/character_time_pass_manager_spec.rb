require 'spec_helper'

describe CharactersServices::Events::SpecialEvents::CharacterTimePassManager do

  let(:id) { CharactersServices::Events::SpecialEvents::CharacterTimePassManager::ID }
  let(:description) { CharactersServices::Events::SpecialEvents::CharacterTimePassManager::DESCRIPTION }
  let(:event_name) { described_class.to_s.split("::").last }

  context 'When the event has been called' do

    context 'When the character updated and still alive' do

      let(:character) { double('Character', id:1, user_id: 1) }
      let(:updated_character) { double('Character') }
      let(:characters) { [ character ] }

      it 'should update the character successfully ' do

        CharactersServices::Events::SpecialEvents::CharacterTimePassManager.new().process

      end
    end

    context 'When the character updated and dying' do

      let(:character) { double('Character', id:1, user_id: 1) }
      let(:updated_character) { double('Character') }
      let(:characters) { [ character ] }
      let(:user_of_character) { double('User', id:1) }

      it 'should update the character successfully ' do

        CharactersServices::Events::SpecialEvents::CharacterTimePassManager.new().process

      end
    end

  end
end