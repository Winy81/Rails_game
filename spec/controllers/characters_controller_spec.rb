require 'spec_helper'
require 'rails_helper'

describe CharactersController, type: :request do

  before do
    current_user = User.create(id:101, email: "test_user@email.com", name: "test_user", role: "user", password:'password')
    Wallet.create(amount: 100, user_id: 101)
    User.create(id:102, email: "test_user2@email.com", name: "test_user2", role: "user", password:'password')
    Character.create(id:1001, name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 3, user_id: 101 )
    Character.create(id:1002, name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 101 )
    Character.create(id:1003, name:'character_3',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 5, user_id: 102 )
    Character.create(id:1004, name:'character_4',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 102 )
    login_as(current_user)
  end

  describe 'GET#index' do

    let(:number_of_all_characters) { Character.all.count}

    it "should return with the logged in user's characters and with all characters" do

    get characters_path

    expect(assigns(:characters).count).to eq(number_of_all_characters)
    expect(assigns(:my_character)).to eq(Character.find_by(id:1002))

    end
  end

end