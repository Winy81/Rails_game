require 'rails_helper'

RSpec.feature 'Character show page' do

  before do
    @user_char_show = User.create(name:'user_char_show', email: 'user_char_show@email.com', password:'password', password_confirmation:'password')
    login_as(@user_char_show)
  end

  feature "When the user try to use actions on others user's Character" do

    before do
      @user_show_unknown = User.create(id:2,name:'user_activity_process', email: 'user_activity_process@email.com', password:'password', password_confirmation:'password')
      @char_of_show_unknown = Character.create(id:2,
                                               name:'char_of_show_unknown',
                                               user_id:2,
                                               status:'alive',
                                               age: 214,
                                               fed_state:50,
                                               activity_require_level:50,
                                               happiness:50)
    end

    scenario 'Should be redirected for Index page with message' do

      visit 'characters/2'

      current_path.should == characters_path
      expect(page).to have_content('That Character is not Yours!')

    end

  end

  feature "When the user try to use actions on it's own character but the character is dead" do

    before do
      @char_show = Character.create(id:1,
                                    name:'@char_show',
                                    user_id:1,
                                    status:'dead',
                                    age: 214,
                                    fed_state:50,
                                    activity_require_level:50,
                                    happiness:50)
    end

    scenario 'Should be redirected for Index page with message' do

      visit 'characters/1'

      current_path.should == characters_path
      expect(page).to have_content('This Character is Dead already!')

    end

  end

  feature "When the user try to use actions on it's own character and the character is alive" do

    before do
      @char_show = Character.create(id:1,
                                    name:'@char_show',
                                    user_id:1,
                                    status:'alive',
                                    age: 214,
                                    fed_state:50,
                                    activity_require_level:50,
                                    happiness:50)
    end

    scenario 'Should be redirected for the show action page' do

      current_character = Character.find_by(id:1)

      visit 'characters/1'

      current_path.should == character_path(current_character)

      expect(page).to have_content('Name Of Character:')
      expect(page).to have_content(current_character.name)
      expect(page).to have_content(current_character.age)
      expect(page).to have_content(current_character.fed_state)
      expect(page).to have_content(current_character.activity_require_level)
      expect(page).to have_content(current_character.happiness)

      expect(page).to have_link('Feeding')
      expect(page).to have_link('Activity')
      expect(page).to have_link('Happiness')
      expect(page).to have_link('Back')

      find(:xpath, "//a[contains(@href,'/character/#{current_character.id}/feeding')]")
      find(:xpath, "//a[contains(@href,'/character/#{current_character.id}/activity')]")
      find(:xpath, "//a[contains(@href,'/character/#{current_character.id}/playing')]")


    end

  end

end

