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

    character_id = @char_of_playing_page.id
    character_current_fed_state = @char_of_playing_page.fed_state
    character_current_happiness = @char_of_playing_page.happiness

    visit "/character/#{@char_of_playing_page.id}/playing"

    expect(page).to have_content('Happiness:')
    expect(page).to have_content(character_current_happiness)
    expect(page).to have_content('Fed State:')
    expect(page).to have_content(character_current_fed_state)

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?happiness=#{character_current_happiness + 2}&extra=from_playing')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?happiness=#{character_current_happiness + 4}&extra=from_playing')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?happiness=#{character_current_happiness + 6}&extra=from_playing')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?happiness=#{character_current_happiness + 8}&extra=from_playing')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?happiness=#{character_current_happiness + 10}&extra=from_playing')]")

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process')]", :count => 5)

    page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

  end
end