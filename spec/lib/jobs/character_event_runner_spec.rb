require 'spec_helper'

describe Jobs::CharacterEventRunner do

  context 'Hit a event call' do

    context 'when CharityEvent rolled' do

      let(:subject) { double(Jobs::CharacterEventRunner )}
      let(:charity_event) { double(CharactersServices::Events::RandomEvents::CharityEvent) }
      let(:random) { double(::Random) }

      it 'should process CharityEvent' do

=begin
        allow(::Random).to receive(:new).and_return(random)
        expect(random).to receive(:rand).with(1..1000).and_return(5)
        expect(subject).to receive(:random_event_caller).with(5)

        expect(CharactersServices::Events::RandomEvents::CharityEvent).to receive(:new).and_return(charity_event)
        expect(charity_event).to receive(:process)

        Jobs::CharacterEventRunner.new().perform
=end

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