require 'rails_helper'

RSpec.feature 'Game description' do

  before do
    @user_for_game_desc = User.create(name:'user_for_game_desc', email:'user_for_game_desc@email.com', password:'password', password_confirmation:'password')
  end

  feature 'Show game description and link library about guides' do

    scenario 'With link into mains#index when no current user' do

      visit'/info/statics/game_description'

      expect(page).to have_content('Age')
      expect(page).to have_content('Status')
      expect(page).to have_content('Activity Require')
      expect(page).to have_content('Fed State')
      expect(page).to have_content('Happiness')
      expect(page).to have_content('Hibernated')

      page.should have_xpath("//a[contains(@href,'mains')]", :count => 1)

    end

    scenario 'With link into characters#index when current user exists' do

      visit'/info/statics/game_description'

      login_as(@user_for_game_desc)

      expect(page).to have_content('Age')
      expect(page).to have_content('Status')
      expect(page).to have_content('Activity Require')
      expect(page).to have_content('Fed State')
      expect(page).to have_content('Happiness')
      expect(page).to have_content('Hibernated')

      page.should have_xpath("//a[contains(@href,'characters')]", :count => 1)

    end

  end

end