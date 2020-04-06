require 'rails_helper'

RSpec.feature 'Characters history page' do

  before do
    @user_c_h = User.create(name:'user_c_h', email: 'user_c_h@email.com', password:'password', password_confirmation:'password')
  end

  feature 'When the checked character not belongs to current user' do

    feature 'When the player has just character with status:alive' do

      before do
        @char_of_user_c_h = Character.create(name:'char_of_user_c_h',user_id:@user_c_h.id)
      end

      scenario 'Should return with one character with its details' do

      end

    end

    feature 'When the player has more than one character character with status:alive' do

      before do
        @char_of_user_c_h_1 = Character.create(name:'char_of_user_c_h_1',user_id:@user_c_h.id,status:'alive')
        @char_of_user_c_h_2 = Character.create(name:'char_of_user_c_h_@',
                                               user_id:@user_c_h.id,
                                               status:'dead')
      end

      scenario 'Has to turn up all of the characters include living time and dieing date' do

      end

    end

  end


  feature 'When the check character not belongs to current user' do

    scenario 'Ha to be redirected fot all_of my_characters_path' do

    end

  end

end
