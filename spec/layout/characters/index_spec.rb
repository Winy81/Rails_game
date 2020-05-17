require 'rails_helper'

RSpec.feature 'Index page' do

  before do
    @character_2 = Character.create(name:'Test_character_2', user_id:2)
    @character_3 = Character.create(name:'Test_character_3', user_id:3)
  end

  feature 'user has not logged in' do

    scenario 'should redirect to mains index with them details' do

      visit '/characters'
      current_path.should == new_user_session_path

      expect(page).to have_link('Sign up')
      expect(page).to have_link('Log in')
      expect(page).to have_content('You need to sign in or sign up first.')
    end

  end

  feature 'when successfully logged in' do

    before do
      @user = User.create(id:1, name:'Test_user', password:'password', password_confirmation:'password')
      login_as(@user)
    end

    scenario 'user has not own character' do

      visit '/characters'
      current_path.should == characters_path

      expect(page).to have_content('Sign Out')
      expect(page).to have_content(@user.name)

      expect(page).to have_content('You have no living Character!')
      find(:xpath, "//a[contains(@href,'/characters/new')]")
      find(:xpath, "//a[contains(@href,'all_of_my_character?extra=from_index')]")

      expect(page).to have_content(@character_2.name)
      expect(page).to have_content(@character_2.age)
      expect(page).to have_content(@character_2.status)

      expect(page).to have_content(@character_3.name)
      expect(page).to have_content(@character_3.age)
      expect(page).to have_content(@character_3.status)

    end

    scenario 'user has now own character' do

      character = Character.create(name:'Test_character', user_id:1)

      visit '/characters'
      current_path.should == characters_path

      find(:xpath, "//a[contains(@href,'/characters/#{character.id}?extra=from_index')]")
      find(:xpath, "//a[contains(@href,'all_of_my_character?extra=from_index')]")

      expect(page).to have_content(character.name)
      expect(page).to have_content(character.age)

      expect(page).to have_content(@character_2.name)
      expect(page).to have_content(@character_2.age)
      expect(page).to have_content(@character_2.status)

      expect(page).to have_content(@character_3.name)
      expect(page).to have_content(@character_3.age)
      expect(page).to have_content(@character_3.status)

    end

  end

end