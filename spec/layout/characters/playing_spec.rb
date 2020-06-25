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

    @user_playing_page_wallet = Wallet.create(user_id:@user_playing_page.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )
  end

  feature 'When the Character exist' do

    feature 'The current user is the owner of the character' do

      scenario 'Should turn up with list of actions with playing main action' do

        character_id = @char_of_playing_page.id
        character_current_activity_state = @char_of_playing_page.activity_require_level
        character_current_fed_state = @char_of_playing_page.fed_state
        character_current_happiness = @char_of_playing_page.happiness
        character_current_name = @char_of_playing_page.name
        users_wallet = @user_playing_page_wallet.amount

        visit "/character/#{@char_of_playing_page.id}/playing"

        expect(page).to have_content('Name Of Character:')
        expect(page).to have_content(character_current_name)
        expect(page).to have_content('Activity require:')
        expect(page).to have_content(character_current_activity_state)
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_current_happiness)
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_current_fed_state)

        expect(page).to have_content(@user_playing_page_wallet.amount)
        expect(@user_playing_page_wallet.amount).to eq(100)

        page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?amount=#{users_wallet - 1}&extra=from_playing&happiness=#{character_current_happiness + 2}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?amount=#{users_wallet - 2}&extra=from_playing&happiness=#{character_current_happiness + 4}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?amount=#{users_wallet - 3}&extra=from_playing&happiness=#{character_current_happiness + 6}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?amount=#{users_wallet - 4}&extra=from_playing&happiness=#{character_current_happiness + 8}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process?amount=#{users_wallet - 5}&extra=from_playing&happiness=#{character_current_happiness + 10}')]")

        page.should have_xpath("//a[contains(@href,'character/#{character_id}/playing_process')]", :count => 5)

        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

      end
    end

    feature 'The current user is NOT the owner of the character' do

      before do
        @extra_user_playing_page = User.create(name:'extra_user_playing_page', email: 'extra_user_playing_page@email.com', password:'password', password_confirmation:'password')
        @extra_char_playing_page = Character.create(name:'extra_char_playing_page',
                                                       user_id:@extra_user_playing_page.id,
                                                       status:'alive',
                                                       age: 214,
                                                       fed_state:10,
                                                       activity_require_level:46,
                                                       happiness:31)
      end

      scenario 'Should return with en error message and redirected for characters page' do

        visit "/character/#{@extra_char_playing_page.id}/playing"

        current_path.should == characters_path
        expect(page).to have_content('That Character is not Yours!')

      end
    end

  end
end