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
      expect(assigns(:my_character)).to eq(Character.find_by(user_id:@current_user.id, status:'alive'))

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

    let(:message) { 'Oops, your character has could not finish the meal ' }

    it 'should redirect into character_path and flash a message' do

      get feeding_process_path(id: @character_first_user_alive.id)

      expect(flash[:alert]).to eq(message)
      response.should redirect_to character_path(@character_first_user_alive)

    end
  end

  describe 'POST#feeding_process' do

    before do
      login_as(@current_user)
    end

    let(:params) { {:id => @character_first_user_alive.id,
                    :amount => 5,
                    :fed_state => 12,
                    :activity_require_level => -1,
                    :happiness => 12 } }

    context 'When the character has not enough activity point to process the action' do

      it 'should redirect to character path with warning message' do

        post feeding_process_path(params)

        expect(flash[:warning]).to eq('Your are too tired to move ')
        response.should redirect_to character_path(@character_first_user_alive)

      end

    end

    context 'When the character has enough activity point but the user has not enough gold to process this action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => -10,
                      :fed_state => 12,
                      :activity_require_level => 7,
                      :happiness => 12 } }

      it 'should redirect to character path with warning message' do

        post feeding_process_path(params)

        expect(flash[:warning]).to eq('Your have not enough Gold for this action ')
        response.should redirect_to character_path(@character_first_user_alive)


      end

    end

    context 'When the user has enough activity point and money to cover the action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => 95,
                      :fed_state => '12',
                      :activity_require_level => '7',
                      :happiness => '12' } }
      let(:current_amount) { params[:amount].to_i }
      let(:current_fed_state) { params[:fed_state] }
      let(:current_activity_state) { params[:activity_require_level] }
      let(:current_happiness_state) { params[:happiness] }
      let(:wallet_view) { @current_user.wallet.amount }

      it 'should processed the action and update the character and wallet details' do

        post feeding_process_path(params)

        expect(assigns(:current_fed_state)).to eq(params[:fed_state])
        expect(assigns(:current_activity_state)).to eq(params[:activity_require_level])
        expect(assigns(:current_happiness_state)).to eq(params[:happiness])
        expect(assigns(:current_amount)).to eq(current_amount)
        expect(assigns(:spendable_amount)).to eq(-1*(@current_user.wallet.amount - current_amount))
        expect(assigns(:costs)).to eq((wallet_view - current_amount))

        expect(assigns(:sent_potion_of_food)).to eq(-1*(@character_first_user_alive.fed_state.to_i - current_fed_state.to_i))
        expect(assigns(:sent_points_of_activity)).to eq(-1*(@character_first_user_alive.activity_require_level.to_i - current_activity_state.to_i))
        expect(assigns(:sent_happiness_points)).to eq(-1*(@character_first_user_alive.happiness.to_i - current_happiness_state.to_i))

      end
    end
  end

  describe 'GET#activity_deny' do

    before do
      login_as(@current_user)
    end

    let(:message) { 'Oops, your character has could not finish the Challenge ' }

    it 'should redirect into character_path and flash a message' do

      get activity_process_path(id: @character_first_user_alive.id)

      expect(flash[:alert]).to eq(message)
      response.should redirect_to character_path(@character_first_user_alive)

    end
  end

  describe 'POST#activity_process' do

    before do
      login_as(@current_user)
    end

    context 'When the character has not enough activity point to process the action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => 5,
                      :fed_state => 12,
                      :activity_require_level => -1,
                      :happiness => 12 } }

      it 'should redirect to character path with warning message' do

        post activity_process_path(params)

        expect(flash[:warning]).to eq('Your are too tired to move ')
        response.should redirect_to character_path(@character_first_user_alive)

      end

    end

    context 'When the character has not enough feed point to process the action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => 5,
                      :fed_state => -1,
                      :activity_require_level => 5,
                      :happiness => 12 } }

      it 'should redirect to character path with warning message' do

        post activity_process_path(params)

        expect(flash[:warning]).to eq('Your are too hungry to move ')
        response.should redirect_to character_path(@character_first_user_alive)

      end

    end

    context 'When the character has enough activity and feed points to cover the action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => 105,
                      :fed_state => '8',
                      :activity_require_level => '5',
                      :happiness => '12' } }
      let(:current_amount) { params[:amount].to_i }
      let(:current_fed_state) { params[:fed_state] }
      let(:current_activity_state) { params[:activity_require_level] }
      let(:current_happiness_state) { params[:happiness] }
      let(:wallet_view) { @current_user.wallet.amount }

      it 'should processed the action and update the character and wallet details' do

        post activity_process_path(params)

        expect(assigns(:current_fed_state)).to eq(params[:fed_state])
        expect(assigns(:current_activity_state)).to eq(params[:activity_require_level])
        expect(assigns(:current_happiness_state)).to eq(params[:happiness])
        expect(assigns(:current_amount)).to eq(current_amount.to_s)
        expect(assigns(:earn)).to eq((-1*(wallet_view - current_amount.to_i)))

        expect(assigns(:sent_potion_of_food)).to eq(-1*(@character_first_user_alive.fed_state.to_i - current_fed_state.to_i))
        expect(assigns(:sent_points_of_activity)).to eq(-1*(@character_first_user_alive.activity_require_level.to_i - current_activity_state.to_i))
        expect(assigns(:sent_happiness_points)).to eq(-1*(@character_first_user_alive.happiness.to_i - current_happiness_state.to_i))

      end
    end
  end

  describe 'GET#playing_deny' do

    before do
      login_as(@current_user)
    end

    let(:message) { 'Oops, your character has not become Happy ' }

    it 'should redirect into character_path and flash a message' do

      get playing_process_path(id: @character_first_user_alive.id)

      expect(flash[:alert]).to eq(message)
      response.should redirect_to character_path(@character_first_user_alive)

    end
  end


  describe 'POST#playing_process' do

    before do
      login_as(@current_user)
    end

    context 'When the character has not enough activity point to process the action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => 5,
                      :fed_state => 12,
                      :activity_require_level => -1,
                      :happiness => 12 } }

      it 'should redirect to character path with warning message' do

        post playing_process_path(params)

        expect(flash[:warning]).to eq('Your are too tired to move ')
        response.should redirect_to character_path(@character_first_user_alive)

      end

    end

    context 'When the character has not enough feed point to process the action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => 5,
                      :fed_state => -1,
                      :activity_require_level => 5,
                      :happiness => 12 } }

      it 'should redirect to character path with warning message' do

        post playing_process_path(params)

        expect(flash[:warning]).to eq('Your are too hungry to move ')
        response.should redirect_to character_path(@character_first_user_alive)

      end

    end

    context 'When the character has enough activity and feed points to cover the action' do

      let(:params) { {:id => @character_first_user_alive.id,
                      :amount => 95,
                      :fed_state => '12',
                      :activity_require_level => '7',
                      :happiness => '12' } }
      let(:current_amount) { params[:amount].to_i }
      let(:current_fed_state) { params[:fed_state] }
      let(:current_activity_state) { params[:activity_require_level] }
      let(:current_happiness_state) { params[:happiness] }
      let(:wallet_view) { @current_user.wallet.amount }

      it 'should processed the action and update the character and wallet details' do

        post playing_process_path(params)

        expect(assigns(:current_fed_state)).to eq(params[:fed_state])
        expect(assigns(:current_activity_state)).to eq(params[:activity_require_level])
        expect(assigns(:current_happiness_state)).to eq(params[:happiness])
        expect(assigns(:current_amount)).to eq(current_amount)
        expect(assigns(:spendable_amount)).to eq(-1*(@current_user.wallet.amount - current_amount))
        expect(assigns(:costs)).to eq((wallet_view - current_amount))

        expect(assigns(:sent_potion_of_food)).to eq(-1*(@character_first_user_alive.fed_state.to_i - current_fed_state.to_i))
        expect(assigns(:sent_points_of_activity)).to eq(-1*(@character_first_user_alive.activity_require_level.to_i - current_activity_state.to_i))
        expect(assigns(:sent_happiness_points)).to eq(-1*(@character_first_user_alive.happiness.to_i - current_happiness_state.to_i))

      end
    end
  end
end