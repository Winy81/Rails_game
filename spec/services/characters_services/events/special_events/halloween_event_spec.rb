require 'spec_helper'

describe CharactersServices::Events::SpecialEvents::HalloweenEvent do

  let(:id) { CharactersServices::Events::SpecialEvents::HalloweenEvent::ID }
  let(:happiness_for_lost) { CharactersServices::Events::SpecialEvents::HalloweenEvent::DECREASED_HAPPINESS_WITH }
  let(:fed_state_for_reach) { CharactersServices::Events::SpecialEvents::HalloweenEvent::INCREASED_FED_STATE_WITH }
  let(:description) { CharactersServices::Events::SpecialEvents::HalloweenEvent::DESCRIPTION }
  let(:event_name) { described_class.to_s.split("::").last }

  context 'When the event has been called' do

    let(:character) { double('Character', id:1, user_id: 1) }
    let(:characters) { [ character ] }

    it 'should update the characters with DECREASED_HAPPINESS_WITH, INCREASED_FED_STATE_WITH' do

      expect(Character).to receive(:active_living_characters).and_return(characters)
      expect(character).to receive(:fed_state_increase_with).with(fed_state_for_reach)
      expect(character).to receive(:happiness_decreased_with).with(happiness_for_lost)
      expect(Event).to receive(:create).with(event_id:id,event_name:event_name,description:description)

      CharactersServices::Events::SpecialEvents::HalloweenEvent.new().process

    end
  end
end