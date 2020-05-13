require 'rails_helper'

include DateTransformHelper

RSpec.feature 'Characters history page' do

  before do
    @user_c_h = User.create(name:'user_c_h', email: 'user_c_h@email.com', password:'password', password_confirmation:'password')
    @user_who_logged_in = User.create(name:'user_who_logged_in', email: 'user_who_logged_in@email.com', password:'password', password_confirmation:'password')
    login_as(@user_who_logged_in)
  end

  feature 'When the checked character not belongs to current user' do

    feature 'When the player has just character with status:alive' do

      before do
        @char_of_user_c_h = Character.create(name:'char_of_user_c_h',user_id:@user_c_h.id)
      end

      scenario 'Should return with one character with its details' do

        all_of_character_of_user_user_c_h = Character.where(user_id:1).count

        visit "/user/#{@user_c_h.id}/characters_history"

        expect(current_path).to eq(characters_history_path(@user_c_h.id))

        expect(page).to have_content('Name of User:')
        expect(page).to have_content( @user_c_h.name)
        expect(page).to have_content('He is member from:')
        expect(page).to have_content(date_view_optimizer(@user_c_h.created_at))

        expect(page).to have_content('Name of Character:', count: all_of_character_of_user_user_c_h)
        expect(page).to have_content('Age:', count: all_of_character_of_user_user_c_h)
        expect(page).to have_content('Status:', count: all_of_character_of_user_user_c_h)

        expect(page).to have_link('Back')
        expect(page).to have_content('Characters Page')

      end

    end

    feature 'When the player has more than one character character with status:alive' do

      before do
        @char_of_user_c_h_1 = Character.create(name:'char_of_user_c_h_1',user_id:@user_c_h.id,status:'alive')
        @char_of_user_c_h_2 = Character.create(name:'char_of_user_c_h_2',
                                               user_id:@user_c_h.id,
                                               status:'dead')
        @char_of_user_c_h_3 = Character.create(name:'char_of_user_c_h_3',
                                               user_id:@user_c_h.id,
                                               status:'dead')
      end

      scenario 'Has to turn up all of the characters include living time and dieing date' do

        all_of_character_of_user_user_c_h = Character.where(user_id:1).count

        visit "/user/#{@user_c_h.id}/characters_history"

        expect(current_path).to eq(characters_history_path(@user_c_h.id))

        expect(page).to have_content('Name of User:')
        expect(page).to have_content( @user_c_h.name)
        expect(page).to have_content('He is member from:')
        expect(page).to have_content(date_view_optimizer(@user_c_h.created_at))

        expect(page).to have_link('Details', count: 1)

        expect(page).to have_content('Name of Character:', count: all_of_character_of_user_user_c_h)
        expect(page).to have_content('Age:', count: all_of_character_of_user_user_c_h)
        expect(page).to have_content('Status:', count: all_of_character_of_user_user_c_h)
        expect(page).to have_content('This Character has died on:', count: all_of_character_of_user_user_c_h - 1)
        expect(page).to have_content('Was living:', count: all_of_character_of_user_user_c_h - 1)

        expect(page).to have_link('Back')
        expect(page).to have_content('Characters Page')

      end

    end

  end


  feature 'When the checked character has belongs to current user' do

    scenario 'Should be redirected fot all_of my_characters_path' do

    end

  end

end
