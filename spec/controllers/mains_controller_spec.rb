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

      before do
        Character.create(name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 3, user_id: 1 )
        Character.create(name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 1 )
      end

      let(:all_character) { Character.all }
      let(:ordered_characters) { all_character.order(:age => :desc) }

      it 'should return with all of the characters in age order' do

        expect(Character).to receive(:all).and_return(all_character)

        expect(all_character).to receive(:age_order_filter).and_return(ordered_characters)

        expect(ordered_characters.first.age).to eq(5)
        expect(ordered_characters.last.age).to eq(3)

        get mains_path

      end

    end
  end

  describe 'GET#show' do


  end

  describe 'GET#leaderboard' do

    before do
      Character.create(name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 3, user_id: 1 )
      Character.create(name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 9, user_id: 2 )
      Character.create(name:'character_3',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 30, user_id: 3 )
      Character.create(name:'character_4',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 90, user_id: 4 )
      Character.create(name:'character_5',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 75, user_id: 5 )
    end

    let(:all_character) { Character.all }
    let(:ordered_characters) { all_character.order(:age => :desc) }

    it 'should return with all of the characters in age order' do

      expect(Character).to receive(:all).and_return(all_character)

      expect(all_character).to receive(:age_order_filter).and_return(ordered_characters)

      expect(ordered_characters.first.age).to eq(90)
      expect(ordered_characters.last.age).to eq(3)

      get mains_path

    end
  end

end