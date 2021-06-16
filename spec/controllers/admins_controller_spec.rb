require 'spec_helper'
require 'rails_helper'

describe AdminsController, type: :request do

  before do
    @admin_user = User.create(id:101, email: "test_user@email.com", name: "test_user", role: "admin", password:'password')
    @not_admin_user = User.create(id:102, email: "test_user2@email.com", name: "test_user2", role: "user", password:'password')
    @character = Character.create(id:1001,
                                  name:'character_1',
                                  fed_state: 10,
                                  happiness:10,
                                  activity_require_level: 10,
                                  status:'dead',
                                  died_on: '2021-09-15 18:36:27',
                                  age: 3,
                                  user_id: 102 )
    Wallet.create(amount: 100, user_id: 101)
    Wallet.create(amount: 100, user_id: 102)
  end

  describe 'before_actions' do

    describe '#is_user_admin?' do

      context 'When the logged in user is a admin' do

        before do
          login_as(@admin_user)
        end

        it 'should trigger the action' do

          get admins_index_path

          expect(flash[:alert]).to eq(nil)

        end
      end

      context 'When the logged in user is NOT a admin' do

        before do
          login_as(@not_admin_user)
        end

        let(:message) { 'You have no admin privileges ' }

        it 'should be redirected into character_path with an alert' do

          get admins_index_path

          expect(flash[:alert]).to eq(message)
          response.should redirect_to characters_path

        end
      end

      context 'When the user has not logged in' do

        let(:message) { 'You have to log in first with admin privileges ' }

        it 'should be redirected into character_path with an alert' do

          get admins_index_path

          expect(flash[:alert]).to eq(message)
          response.should redirect_to characters_path

        end
      end
    end

    describe '#admin_path_recogniser?' do

      before do
        login_as(@admin_user)
      end

      context 'When the path is admin_path' do

        let(:params) { { :controller => 'admins' } }

        it 'should return true' do

          get admins_index_path

          expect(assigns(:admin_path)).to eq(true)

        end
      end
    end
  end

  describe 'GET#edit_user' do

    before do
      login_as(@admin_user)
    end

    let(:params) { { id:@not_admin_user.id } }

    it 'should return with a user whos id is same as params_id' do

      get edit_user_path(params)

      expect(assigns(:user)).to eq(@not_admin_user)

    end
  end

  describe 'GET#edit_character' do

    before do
      login_as(@admin_user)
    end

    let(:params) { { id:@character.id } }

    it 'should return with a character whos id is same as params_id' do

      get edit_character_path(params)

      expect(assigns(:character)).to eq(@character)

    end
  end

  describe 'GET#user_update_by_admin' do

    before do
      login_as(@admin_user)
    end


    context 'if successfully updated' do

      let(:message) { 'User details has been updated.' }
      let(:new_budget) { 10000 }
      let(:params) { { :id => @not_admin_user.id,
                       :user => { :id => @not_admin_user.id,
                                  :name => @not_admin_user.name,
                                  :email => @not_admin_user.email,
                                  :role => 'user',
                                  :budget => new_budget} } }


      it 'should update users details and return with a notice' do

        patch user_update_by_admin_path(params)

        expect(flash[:notice]).to eq(message)
        expect(assigns(:user)).to eq(@not_admin_user)
        expect(@not_admin_user.wallet.amount).to eq(new_budget)

      end
    end

    context 'if NOT successfully updated' do

      let(:params) { {} }

      it 'should return with an error' do

        #patch user_update_by_admin_path(params)

        #expect(assigns(:user)).to eq(@not_admin_user)

      end
    end
  end

  describe 'GET#character_update_by_admin' do

    before do
      login_as(@admin_user)
    end

    context 'if successfully updated' do

      let(:new_name_of_character) { 'NeW_NaMe' }
      let(:message) { 'Character details has updated.' }
      let(:params) { { :id => @character.id,
                       :character => { :id => @character.id,
                                       :name => new_name_of_character } } }

      it 'should update users details and return with a notice' do

        patch character_update_by_admin_path(params)

        expect(flash[:notice]).to eq(message)
        expect(assigns(:character)).to eq(@character)
        expect(Character.find_by(id:@character.id).name).to eq(new_name_of_character)

      end
    end

    context 'if NOT successfully updated' do

      let(:new_name_of_character) { 'NeW_NaMe' }
      let(:message) { 'Character details has updated.' }
      let(:params) { { :id => @character.id } }

      it 'should update users details and return with a notice' do

        #patch character_update_by_admin_path(params)

        #expect(flash[:alert]).to eq(message)

      end
    end

    describe 'GET#account_management' do

      before do
        login_as(@admin_user)
      end

      it 'should return with all user in ASC order by user_id' do

        users_in_order = User.all.order(:id => :asc)

        expect(User).to receive(:users_in_asc_id_order).and_return(users_in_order)

        get account_management_path

      end
    end

    describe 'GET#character_management' do

      before do
        login_as(@admin_user)
      end

      let(:all_characters) { Character.all }

      it 'should return with all character in ASC order by user_id' do

        characters_in_order = all_characters.order(:id => :asc)

        allow(Character).to receive(:all).and_return(all_characters)
        expect(all_characters).to receive(:character_in_asc_id_order).and_return(characters_in_order)

        get character_management_path

      end
    end

    describe 'GET#search' do

      before do
        login_as(@admin_user)
      end

      context 'when account search' do

        let(:params) { { :search_params => 'character_1',
                         :commit => 'Search User' } }
        let(:instance_of_search) { double(Services::SearchEngine::Search) }
        let(:response_of_search) { [{'name' => 'test_user2',
                                     'search_type' => 'account',
                                     'email' => 'test_user2@email.com'}]}

        it 'should return with user based on search' do

          expect(Services::SearchEngine::Search).to receive(:new).with(params[:search_params], params[:commit]).and_return(instance_of_search)
          expect(instance_of_search).to receive(:response).and_return(response_of_search)

          post search_admins_path(params)

          expect(assigns(:users)).to eq(response_of_search)

        end

      end

      context 'when character search' do

        let(:params) { { :search_params => 'character_1',
                         :commit => 'Search Character' } }
        let(:instance_of_search) { double(Services::SearchEngine::Search) }
        let(:response_of_search) { [{'name' => 'character_1',
                                     'search_type' => 'character',
                                     'user_id' => 102}]}

        it 'should return with character based on search' do

          expect(Services::SearchEngine::Search).to receive(:new).with(params[:search_params], params[:commit]).and_return(instance_of_search)
          expect(instance_of_search).to receive(:response).and_return(response_of_search)

          post search_admins_path(params)

          expect(assigns(:characters)).to eq(response_of_search)

        end
      end
    end
  end
end
