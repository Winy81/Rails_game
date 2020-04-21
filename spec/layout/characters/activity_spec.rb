require 'rails_helper'

RSpec.feature 'Activity page' do

  before do
    @user_activity_page = User.create(name:'user_activity_page', email: 'user_activity_page@email.com', password:'password', password_confirmation:'password')
    login_as(@user_activity_page)

    @user_activity_page = Character.create(name:'char_activity_page',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:10,
                                             activity_require_level:46,
                                             happiness:31)
  end

  scenario 'Should turn up with list of activities' do

    character_id = @user_activity_page.id
    character_current_activity_state = @user_activity_page.activity_require_level
    character_current_happiness = @user_activity_page.happiness

    visit "/character/#{@user_activity_page.id}/feeding"

    expect(page).to have_content('Activity State:')
    expect(page).to have_content(character_current_activity_state)
    expect(page).to have_content('Happiness:')
    expect(page).to have_content(character_current_happiness)

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_activity&activity_require_level=#{character_current_activity_state + 5}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_activity&activity_require_level=#{character_current_activity_state + 10}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_activity&activity_require_level=#{character_current_activity_state + 15}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_activity&activity_require_level=#{character_current_activity_state + 20}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_activity&activity_require_level=#{character_current_activity_state + 25}')]")

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/from_activity_process')]", :count => 5)

    page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

  end

end