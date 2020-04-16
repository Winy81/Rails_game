require 'rails_helper'

RSpec.feature 'Feeding process page' do

  before do
    @user_feeding_process = User.create(name:'user_feeding_process', email: 'user_feeding_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_feeding_process)

    @char_of_feeding_proc = Character.create(name:'char_of_feeding_proc',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:10,
                                             activity_require_level:60,
                                             happiness:50)
  end

  feature 'Should be redirected for action page with GET request' do

    scenario 'When called the page from outside' do

    end

    scenario 'When the data manually changed' do

    end

  end

  feature 'Should be proceed with POST request' do

    scenario 'Should be turn up with page with claim-able details and process button' do

    end

  end

end