require 'rails_helper'

RSpec.feature 'Feeding process page' do

  before do
    @user_char_new = User.create(name:'user_activity_process', email: 'user_activity_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_char_new)
  end

  feature 'When the user has NOT character alive' do

    scenario 'Should be not proceed and create a character' do

      name_of_next_char = 'Test_character'

      number_of_character_before = Character.where(user_id:1).count
      expect(number_of_character_before).to eq(0)

      visit 'characters'
      find(:xpath, "//a[contains(@href,'/characters/new')]").click

      fill_in 'character_name', with: name_of_next_char
      click_button 'Create'

      number_of_character_after = Character.where(user_id:1).count
      current_character = Character.find_by(user_id:1)

      current_path.should == character_path(current_character)
      expect(page).to have_content("Tha character has born. You gave name: #{name_of_next_char}")
      character_activity_path(current_character)
      expect(number_of_character_after).to eq(1)

    end
  end

  feature 'When the user has character alive' do

    before do
      @char_of_new = Character.create(name:'@char_of_new',
                                      user_id:1,
                                      status:'alive',
                                      age: 214,
                                      fed_state:50,
                                      activity_require_level:5,
                                      happiness:50)
    end

    scenario 'Should be not proceed and redirected for character page with message' do

      number_of_character = Character.where(user_id:1).count

      visit 'characters/new'

      current_path.should == characters_path
      expect(page).to have_content('You have a character Alive')
      expect(number_of_character).to eq(1)

    end
  end
end