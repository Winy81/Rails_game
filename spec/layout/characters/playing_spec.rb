require 'rails_helper'

RSpec.feature 'Playing page' do

  before do
    @user_playing_page = User.create(name:'user_playing_page', email: 'user_playing_page@email.com', password:'password', password_confirmation:'password')
    login_as(@user_playing_page)

    @char_of_playing_page = Character.create(name:'char_of_playing_page',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:10,
                                             activity_require_level:46,
                                             happiness:31)
  end

  scenario 'Should turn up with list of playings' do

    character_id = @user_playing_page.id
    character_current_fed_state = @user_playing_page.fed_state
    character_current_happiness = @user_playing_page.happiness

    visit "/character/#{@char_of_feeding_page.id}/playing"

  end
end