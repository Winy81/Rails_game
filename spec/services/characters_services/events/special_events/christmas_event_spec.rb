require 'spec_helper'

describe CharactersServices::Events::SpecialEvents::ChristmasEvent do

  let(:id) { CharactersServices::Events::SpecialEvents::ChristmasEvent::ID }
  let(:gold_for_reach) { CharactersServices::Events::SpecialEvents::ChristmasEvent::GOLD_FOR_REACH }
  let(:description) { CharactersServices::Events::SpecialEvents::ChristmasEvent::DESCRIPTION }
  let(:event_name) { described_class.to_s.split("::").last }

  context 'When the event has been called' do

    let(:character) { double('Character', id:1, user_id: 1) }
    let(:characters) { [ character ] }
    let(:user_of_character) { double('User', id:1) }
    let(:budget) {double('Wallet', id:1, amount:20 )}
    let(:updated_budget) { budget.amount + gold_for_reach }

    it 'should update the characters owner budget with GOLD_FOR_REACH' do

      expect(Character).to receive(:active_living_characters).and_return(characters)
      allow(character).to receive(:user).and_return(user_of_character)
      expect(user_of_character).to receive(:budget).and_return(budget.amount)
      expect(user_of_character).to receive(:set_budget).and_return(updated_budget)
      expect(Event).to receive(:create).with(event_id:id,event_name:event_name,description:description)

      CharactersServices::Events::SpecialEvents::ChristmasEvent.new().process

    end

  end

end
