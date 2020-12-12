require 'spec_helper'

describe CharactersServices::Events::RandomEvents::CharityEvent do

  let(:id) { CharactersServices::Events::RandomEvents::CharityEvent::ID }
  let(:gold_for_lost) { CharactersServices::Events::RandomEvents::CharityEvent::GOLD_FOR_LOST }
  let(:description) { CharactersServices::Events::RandomEvents::CharityEvent::DESCRIPTION }
  let(:event_name) { described_class.to_s.split("::").last }
  let(:character) { double(Character) }
  let(:event) { double(Event) }

  context 'When the event has been called' do

    it 'should update the characters owner budget with GOLD_FOR_LOST' do

    end
    
  end

end


