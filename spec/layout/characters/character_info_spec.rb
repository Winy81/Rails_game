require 'rails_helper'

include CharactersHelper

RSpec.feature 'Character info page' do

  before do
    @user_char_info = User.create(name:'user_char_info', email: 'user_char_info@email.com', password:'password', password_confirmation:'password')
    login_as(@user_char_info)

    @character_1 = Character.create(name:'char_user_char_info',
                                    user_id:1,
                                    status:'alive',
                                    age: 214,
                                    fed_state:56,
                                    activity_require_level:46,
                                    happiness:31)

    @user_char_info_wallet = Wallet.create(user_id:@user_char_info.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )

  end

  scenario 'Should turn up with details of Character' do

    id_for_link = @user_char_info.id

    visit "/character_info/#{@character_1.id}"

    find(:xpath, "//a[contains(@href,'user/#{id_for_link}/characters_history')]")
    page.all(:xpath, "//a[contains(@href,'characters')]")

    expect(page).to have_content(@user_char_info_wallet.amount)
    expect(@user_char_info_wallet.amount).to eq(100)

    expect(page).to have_content('Character Information')
    expect(page).to have_content('Character:')
    expect(page).to have_content(@character_1.name)
    expect(page).to have_content('Age Of Character:')
    expect(page).to have_content(@character_1.age)
    expect(page).to have_content('Status:')
    expect(page).to have_content(@character_1.status)
    expect(page).to have_content('Fed State:')
    expect(page).to have_content(@character_1.fed_state)
    expect(page).to have_content('Activity:')
    expect(page).to have_content(@character_1.activity_require_level)
    expect(page).to have_content('Happiness:')
    expect(page).to have_content(@character_1.happiness)
    expect(page).to have_content('Accurate life length:')
    expect(page).to have_content(life_length_counter(@character_1))

  end

end