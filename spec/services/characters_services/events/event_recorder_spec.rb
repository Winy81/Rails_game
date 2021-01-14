require 'spec_helper'

describe CharactersServices::Events::EventRecorder do

  context 'When the Service has been called' do

    let(:id) { 1 }
    let(:event_name) { 'test event' }
    let(:description) { 'description of test event' }

    it 'should create a record with arguments' do

      CharactersServices::Events::EventRecorder.new().event_recording(id,event_name,description)

      expect(Event.last.event_id).to eq(1)
      expect(Event.last.event_name).to eq('test event')
      expect(Event.last.description).to eq('description of test event')

    end
  end
end