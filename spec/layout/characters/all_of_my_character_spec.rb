require 'rails_helper'

RSpec.feature 'All of my character page' do

  feature 'Has to turn up all of the current user Character'

  before do
    @user_all_of_my_c = User.create(name:'user_all_of_my_c', email: 'user_all_of_my_c@email.com', password:'password', password_confirmation:'password')
    login_as(@user_all_of_my_c)
  end

  feature 'User has no character' do

    scenario 'Has to turn up with link and no character text' do

      visit '/all_of_my_character'

      expect(current_path).to eq(all_of_my_character_path)
      expect(page).to have_content(@user_all_of_my_c.name)
      expect(page).to have_content('Your characters history')
      expect(page).to have_content('You have no Character!')
      expect(page).to have_link('Create one now')
      expect(page).to have_link('Back')
      expect(page).to have_content('Characters Page')

    end

  end

  feature 'User has character' do

    before do
      @character_2_of_user = Character.create(name:'Test_char_2_of_user', user_id:1, status:'dead')
      @character_3_of_user = Character.create(name:'Test_char_3_of_user', user_id:1, status:'dead')
    end

    scenario 'User has not character alive' do

      all_of_character_of_user_all_of_my_c = Character.where(user_id:1).count

      visit '/all_of_my_character'

      expect(current_path).to eq(all_of_my_character_path)
      expect(page).to have_content(@user_all_of_my_c.name)
      expect(page).to have_content('Your characters history')
      expect(page).to have_content('Name:', count: all_of_character_of_user_all_of_my_c)
      expect(page).to have_content('Age:', count: all_of_character_of_user_all_of_my_c)
      expect(page).to have_content('Was living:', count: all_of_character_of_user_all_of_my_c)
      expect(page).to have_content('Status: dead', count: all_of_character_of_user_all_of_my_c)
      expect(page).to have_link('Back')
      expect(page).to have_content('Characters Page')

    end


    scenario 'User has character alive' do

      @character_1_of_user = Character.create(name:'Test_char_1_of_user', user_id:1, status:'alive')

      all_of_character_of_user_all_of_my_c = Character.where(user_id:1).count
      character_alive = Character.where(user_id:1, status:'alive').count

      visit '/all_of_my_character'

      expect(current_path).to eq(all_of_my_character_path)
      expect(page).to have_link('Go', count:1)
      expect(page).to have_content(@user_all_of_my_c.name)
      expect(page).to have_content('Your characters history')
      expect(page).to have_content('Status: alive', count: character_alive)
      expect(page).to have_content('Age:', count: all_of_character_of_user_all_of_my_c)
      expect(page).to have_content('Name:', count: all_of_character_of_user_all_of_my_c)
      expect(page).to have_content('Was living:', count: all_of_character_of_user_all_of_my_c - character_alive)
      expect(page).to have_content('Status: dead', count: all_of_character_of_user_all_of_my_c - character_alive)
      expect(page).to have_link('Back')
      expect(page).to have_content('Characters Page')

    end
  end
end