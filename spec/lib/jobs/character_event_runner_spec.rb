require 'spec_helper'

describe Jobs::CharacterEventRunner do

  context 'Hit a event call' do

    context 'when CharityEvent rolled' do

      let(:service) {double(Jobs::CharacterEventRunner)}
      let(:charity_event) { double(CharactersServices::Events::RandomEvents::CharityEvent) }
      #let(:random_event_selector) { 5 }

      before do

      end

      it 'should process CharityEvent' do

        service.should_receive(:random_event_selector).and_return(5)
        expect(service).to receive(:random_event_caller).with(:random_event_selector)

        Jobs::CharacterEventRunner.new().perform
      end
    end

    it 'should process WorldHuntingEvent' do


      Jobs::CharacterEventRunner.new().perform
    end

    it 'should process GoldRainEvent' do


      Jobs::CharacterEventRunner.new().perform
    end

    it 'should process WorldBossEvent' do


      Jobs::CharacterEventRunner.new().perform
    end

  end
end