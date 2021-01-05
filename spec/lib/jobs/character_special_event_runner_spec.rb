require 'spec_helper'

describe Jobs::CharacterSpecialEventRunner do

  context 'Hit a event call' do

    context 'When Christmas time' do

      before do
        new_time = Time.local(2020, 12, 24, 6, 0, 0)
        Timecop.travel(new_time)
      end

      it 'should process ChristmasEvent' do

        Jobs::CharacterSpecialEventRunner.new().perform

        expect(Event.last(2).first.event_name).to eq('ChristmasEvent')
        expect(Event.last.event_name).to eq('CharacterTimePassManager')

      end
    end

    context 'When New Years Eve time' do

      before do
        new_time = Time.local(2020, 1, 1, 0, 0, 0)
        Timecop.travel(new_time)
      end

      it 'should process NewYearsEvent' do

        Jobs::CharacterSpecialEventRunner.new().perform

        expect(Event.last(2).first.event_name).to eq('NewYearsEvent')
        expect(Event.last.event_name).to eq('CharacterTimePassManager')

      end
    end
  end

end