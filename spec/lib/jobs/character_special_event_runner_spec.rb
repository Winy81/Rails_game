require 'spec_helper'

describe Jobs::CharacterSpecialEventRunner do

  context 'Hit a event call' do

    let(:EVENT_1) {double(Jobs::CharacterSpecialEventRunner::SpecialEventList::Events::SpecialEvents::CharacterTimePassManager)}
    let(:EVENT_2) {double(Jobs::CharacterSpecialEventRunner::SpecialEventList::Events::SpecialEvents::ChristmasEvent)}

    context 'When Christmas time' do

      let(:service) {double(Jobs::CharacterSpecialEventRunner)}
      let(:christmas_event) {double(CharactersServices::Events::SpecialEvents::ChristmasEvent)}
      let(:christmas_date) { "12-24--06-00" }

      it 'should process ChristmasEvent' do

        new_time = Time.local(2020, 12, 24, 6, 0, 0)
        Timecop.travel(new_time)

        Jobs::CharacterSpecialEventRunner.new().perform

        expect(Event.last.event_name).to eq('CharacterTimePassManager')
        expect(Event.last(2).first.event_name).to eq('ChristmasEvent')

      end
    end
  end

end