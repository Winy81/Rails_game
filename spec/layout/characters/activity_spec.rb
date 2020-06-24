require 'rails_helper'

RSpec.feature 'Activity page' do

  before do
    @user_activity_page = User.create(name:'user_activity_page', email: 'user_activity_page@email.com', password:'password', password_confirmation:'password')
    login_as(@user_activity_page)

    @character_activity_page = Character.create(name:'char_activity_page',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:10,
                                             activity_require_level:46,
                                             happiness:31)

    @user_activity_page_wallet = Wallet.create(user_id:@user_activity_page.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )

  end

  scenario 'Should turn up with list of activities' do

    character_id = @user_activity_page.id

    character_current_activity_state = @character_activity_page.activity_require_level
    character_current_fed_state = @character_activity_page.fed_state
    character_current_happiness = @character_activity_page.happiness
    users_wallet = @user_activity_page_wallet.amount

    visit "/character/#{@character_activity_page.id}/activity"

    expect(page).to have_content('Name Of Character:')
    expect(page).to have_content(@character_activity_page.name)
    expect(page).to have_content('Activity require:')
    expect(page).to have_content(character_current_activity_state)
    expect(page).to have_content('Fed State: ')
    expect(page).to have_content(character_current_fed_state)
    expect(page).to have_content('Happiness:')
    expect(page).to have_content(character_current_happiness)

    expect(page).to have_content(@user_activity_page_wallet.amount)
    expect(@user_activity_page_wallet.amount).to eq(100)

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?activity_require_level=#{character_current_activity_state - 2}&amount=#{users_wallet + 2}&extra=from_activity')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?activity_require_level=#{character_current_activity_state - 4}&amount=#{users_wallet + 4}&extra=from_activity')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?activity_require_level=#{character_current_activity_state - 6}&amount=#{users_wallet + 6}&extra=from_activity')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?activity_require_level=#{character_current_activity_state - 8}&amount=#{users_wallet + 8}&extra=from_activity')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?activity_require_level=#{character_current_activity_state - 10}&amount=#{users_wallet + 10}&extra=from_activity')]")

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process')]", :count => 5)

    page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

  end

end