require 'rails_helper'

RSpec.describe Event, type: :model do

  describe 'validations' do

    describe 'built in validations' do

      it { is_expected.to validate_presence_of :event_id }
      it { is_expected.to validate_presence_of :event_name }
      it { is_expected.to validate_presence_of :description }

    end

    describe 'custom validations' do

      context 'exist Event' do

        context 'valid' do

          let(:event_id) { CharactersServices::Events::RandomEvents::CharityEvent::ID }
          let(:event_name) { 'test' }
          let(:description) { 'description of test event'}

          it 'Should create an Event' do

            current_number_of_event = Event.count
            Event.create(event_id:event_id,event_name:event_name,description:description)
            updated_number_of_event = Event.count
            expect(updated_number_of_event).to eq(current_number_of_event + 1)

          end
        end

        context 'invalid' do

          let(:event_id) { 123456 }
          let(:event_name) { 'test' }
          let(:description) { 'description of test event'}

          it 'Should NOT create an Event' do

            current_number_of_event = Event.count
            event = Event.create(event_id:event_id,event_name:event_name,description:description)
            updated_number_of_event = Event.count
            expect(updated_number_of_event).to eq(current_number_of_event)
            expect(event.errors.messages).to eq({:event_id=>[" : #{event_id} is a NOT valid event_id"]})
          end
        end
      end
    end
  end
end
