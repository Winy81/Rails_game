require 'spec_helper'
require 'rails_helper'

describe CharactersController, type: :request do

  before do
    @current_user = User.create(id:101, email: "test_user@email.com", name: "test_user", role: "user", password:'password')
    Wallet.create(amount: 100, user_id: 101)
    User.create(id:102, email: "test_user2@email.com", name: "test_user2", role: "user", password:'password')
    Character.create(id:1001, name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', died_on: '2021-09-15 18:36:27', age: 3, user_id: 101 )
    Character.create(id:1002, name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 101 )
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

    it "should return with all of the character belongs for the logged in user in desc order" do

      get all_of_my_character_path
      
      expect(assigns(:characters)).to eq (ordered_characters)
      expect(assigns(:characters).count).to eq(number_of_characters_belongs_current_user)

    end
  end
end