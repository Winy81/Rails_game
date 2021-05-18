require 'spec_helper'
require 'rails_helper'

describe CharactersController, type: :request do

  before do
    @current_user = User.create(id:101, email: "test_user@email.com", name: "test_user", role: "user", password:'password')
    @not_current_user = User.create(id:102, email: "test_user2@email.com", name: "test_user2", role: "user", password:'password')
    Wallet.create(amount: 100, user_id: 101)
    Wallet.create(amount: 100, user_id: 102)
    @character_first_user_dead = Character.create(id:1001, name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', died_on: '2021-09-15 18:36:27', age: 3, user_id: 101 )
    @character_first_user_alive = Character.create(id:1002, name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 101 )
    Character.create(id:1003, name:'character_3',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', died_on: '2021-09-15 18:36:27',age: 5, user_id: 102 )
    Character.create(id:1004, name:'character_4',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 102 )
  end

  describe 'GET#index' do

    let(:number_of_all_characters) { Character.all.count}

    before do
      login_as(@current_user)
    end

    it "should return with the logged in user's characters and with all characters" do

      get characters_path

      expect(assigns(:characters).count).to eq(number_of_all_characters)
      expect(assigns(:my_character)).to eq(Character.find_by(id:1002))

    end
  end

  describe 'GET#all_of_my_character' do

    let(:characters_belongs_current_user) { Character.where(user_id:@current_user.id) }
    let(:number_of_characters_belongs_current_user) { Character.where(user_id:@current_user.id).count }
    let(:ordered_characters) { Character.where(user_id:@current_user.id).order(:id => :desc) }

    before do
      login_as(@current_user)
    end

    it 'should return with all of the character belongs for the logged in user in desc order' do

      get all_of_my_character_path

      expect(assigns(:characters)).to eq (ordered_characters)
      expect(assigns(:characters).count).to eq(number_of_characters_belongs_current_user)

    end
  end

  describe 'GET#characters_history' do

    before do
      login_as(@current_user)
    end

    context 'When the user would like to check his own character history' do

      let(:current_user_id) { @current_user.id }

      it 'should be redirected into all_of_my_character page' do

        get characters_history_path(id: current_user_id)

        response.should redirect_to all_of_my_character_path

      end

    end

    context 'When the user would like to check a other users character history' do

      let(:not_current_user_id) { @not_current_user.id }
      let(:list_of_character_of_not_current_user) { Character.where(user_id:not_current_user_id) }

      it 'should return with all of the users character in desc order but the first is the newest in alive' do

        get characters_history_path(id: not_current_user_id)

        expect(assigns(:owner_of_character)).to eq(@not_current_user)
        expect(assigns(:owners_characters)).to eq(list_of_character_of_not_current_user.characters_history_order_logic)

      end
    end
  end

  describe 'GET#feeding_deny' do

    before do
      login_as(@current_user)
    end

    let(:message) { "Oops, your character has could not finish the meal " }

    it 'should redirect into character_path and flash a message' do

      get feeding_process_path(id: @character_first_user_alive.id)

      expect(flash[:alert]).to eq(message)
      response.should redirect_to character_path(@character_first_user_alive)

    end
  end



end