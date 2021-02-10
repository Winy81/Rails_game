require 'spec_helper'

describe MainsController, type: :request do

  describe 'GET#index' do

    context 'if NO exist character' do

      let(:character) {double(Character)}

      it 'should return with NO character' do

        expect(Character).to receive(:all).and_return(character)
        expect(character).to receive(:age_order_filter).and_return(character)
        expect(character).to receive(:limit).with(10).and_return([])

        get mains_path

      end
    end

    context 'if exist characters' do
      
    end
  end
end