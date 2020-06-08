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
    \
    @user_feeding_page_wallet = Wallet.create(user_id:@user_feeding_page.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )

  end

  scenario 'Should turn up with list of foods' do

    character_id = @char_of_feeding_page.id
    character_current_fed_state = @char_of_feeding_page.fed_state
    character_current_happiness = @char_of_feeding_page.happiness
    users_wallet = @user_feeding_page_wallet.amount

    visit "/character/#{@char_of_feeding_page.id}/feeding"

    expect(page).to have_content('Fed State:')
    expect(page).to have_content(character_current_fed_state)
    expect(page).to have_content('Happiness:')
    expect(page).to have_content(character_current_happiness)

    expect(page).to have_content(@user_feeding_page_wallet.amount)
    expect(@user_feeding_page_wallet.amount).to eq(100)

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 5}&amount=#{users_wallet - 3}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 10}&amount=#{users_wallet - 6}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 15}&amount=#{users_wallet - 9}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 20}&amount=#{users_wallet - 12}')]")
    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + 25}&amount=#{users_wallet - 15}')]")

    page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process')]", :count => 5)

    page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

  end
end