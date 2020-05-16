require 'rails_helper'

RSpec.feature 'Feeding process page' do

  before do
    @user_char_new = User.create(name:'user_activity_process', email: 'user_activity_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_char_new)
  end

  feature 'When the user has NOT character alive' do

    scenario 'Should be not proceed and create a character' do


    end

  end

  feature 'When the user has character alive' do

    @char_of_new = Character.create(name:'@char_of_new',
                                    user_id:1,
                                    status:'alive',
                                    age: 214,
                                    fed_state:50,
                                    activity_require_level:5,
                                    happiness:50)

    scenario 'Should be not proceed and redirected for character page with message' do


    end

  end

end