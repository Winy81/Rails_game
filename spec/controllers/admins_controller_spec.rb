require 'rails_helper'

RSpec.describe AdminsController, type: :request do

  before do
    @admin_user = User.create(id:101, email: "test_user@email.com", name: "test_user", role: "admin", password:'password')
    @not_admin_user = User.create(id:102, email: "test_user2@email.com", name: "test_user2", role: "user", password:'password')
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
end
