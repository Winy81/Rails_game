require 'rails_helper'

RSpec.feature 'Feeding page' do

  before do
    @user_feeding_page = User.create(name:'user_feeding_page', email: 'user_feeding_page@email.com', password:'password', password_confirmation:'password')
    login_as(@user_feeding_page)

    @char_of_feeding_page = Character.create(name:'char_feeding_page',
                                    user_id:1,
                                    status:'alive',
                                    age: 214,
                                    fed_state:10,
                                    activity_require_level:46,
                                    happiness:31)
  end

  scenario 'Should turn up with list of food' do

    character_id = @char_of_feeding_page.id
    character_current_fed_state = @char_of_feeding_page.fed_state

    visit "/character/#{@char_of_feeding_page.id}/feeding"

    expect(page).to have_content('Your Fed State is:')
    expect(page).to have_content(character_current_fed_state)

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 5}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 10}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 15}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 20}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 25}')]")

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process')]", :count => 5)

    page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")
  end
end