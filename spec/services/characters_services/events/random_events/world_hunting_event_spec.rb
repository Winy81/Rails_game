require 'spec_helper'

describe CharactersServices::Events::RandomEvents::WorldHuntingEvent do

  let(:id) { CharactersServices::Events::RandomEvents::WorldHuntingEvent::ID }
  let(:happiness_for_reach) { CharactersServices::Events::RandomEvents::WorldHuntingEvent::INCREASED_HAPPINESS_WITH }
  let(:fed_state_for_reach) { CharactersServices::Events::RandomEvents::WorldHuntingEvent::INCREASED_FED_STATE_WITH }
  let(:activity_for_lost) { CharactersServices::Events::RandomEvents::WorldHuntingEvent::REDUCED_ACTIVITY_LEVEL_WITH }
  let(:description) { CharactersServices::Events::RandomEvents::WorldHuntingEvent::DESCRIPTION }
  let(:event_name) { described_class.to_s.split("::").last }

  context 'When the event has been called' do

    let(:character) { double('Character', id:1, user_id: 1) }
    let(:characters) { [ character ] }

    it 'should update the characters with INCREASED_HAPPINESS_WITH, INCREASED_FED_STATE_WITH, REDUCED_ACTIVITY_LEVEL_WITH' do

      expect(Character).to receive(:active_living_characters).and_return(characters)
      expect(character).to receive(:activity_require_level_decrease_with).with(activity_for_lost)
      expect(character).to receive(:fed_state_increase_with).with(fed_state_for_reach)
      expect(character).to receive(:happiness_increase_with).with(happiness_for_reach)
      expect(Event).to receive(:create).with(event_id:id,event_name:event_name,description:description)

      CharactersServices::Events::RandomEvents::WorldHuntingEvent.new().process

    end
  end
end