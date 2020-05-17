require 'rails_helper'

RSpec.feature 'Character show page' do

  before do
    @user_char_show = User.create(name:'user_char_show', email: 'user_char_show@email.com', password:'password', password_confirmation:'password')
    login_as(@user_char_show)
  end

  feature "When the user try to use actions on others user's Character" do

    before do
      @user_show_unknown = User.create(id:2,name:'user_activity_process', email: 'user_activity_process@email.com', password:'password', password_confirmation:'password')
      @char_of_show_unknown = Character.create(name:'char_of_show_unknown',
                                               user_id:2,
                                               status:'alive',
                                               age: 214,
                                               fed_state:50,
                                               activity_require_level:50,
                                               happiness:50)
    end

    scenario 'Should be redirected for Index page with message' do

    end

  end

  feature "When the user try to use actions on it's own character but the character is dead" do

    before do
      @char_show = Character.create(name:'@char_show',
                                    user_id:1,
                                    status:'dead',
                                    age: 214,
                                    fed_state:50,
                                    activity_require_level:50,
                                    happiness:50)
    end

    scenario 'Should be redirected for Index page with message' do

    end

  end

  feature "When the user try to use actions on it's own character and the character is alive" do

    before do
      @char_show = Character.create(name:'@char_show',
                                    user_id:1,
                                    status:'alive',
                                    age: 214,
                                    fed_state:50,
                                    activity_require_level:50,
                                    happiness:50)
    end

    scenario 'Should be redirected for the show action page' do

    end

  end

end

