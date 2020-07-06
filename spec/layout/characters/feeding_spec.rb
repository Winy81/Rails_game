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

  feature 'When the Character exist' do

    feature 'The current user is the owner of the character' do

      scenario 'Should turn up with list of actions with feeding main action' do

        character_id = @char_of_feeding_page.id
        character_current_activity_state = @char_of_feeding_page.activity_require_level
        character_current_fed_state = @char_of_feeding_page.fed_state
        character_current_happiness = @char_of_feeding_page.happiness
        character_current_name = @char_of_feeding_page.name
        users_wallet = @user_feeding_page_wallet.amount

        link_for_feeding_process_small = "activity_require_level=#{character_current_activity_state - 1}&amount=#{users_wallet - 5}&extra=from_feeding&fed_state=#{character_current_fed_state + 5}&happiness=#{character_current_happiness + 1}"
        link_for_feeding_process_minor = "activity_require_level=#{character_current_activity_state - 2}&amount=#{users_wallet - 10}&extra=from_feeding&fed_state=#{character_current_fed_state + 10}&happiness=#{character_current_happiness + 2}"
        link_for_feeding_process_normal = "activity_require_level=#{character_current_activity_state - 3}&amount=#{users_wallet - 15}&extra=from_feeding&fed_state=#{character_current_fed_state + 15}&happiness=#{character_current_happiness + 3}"
        link_for_feeding_process_large = "activity_require_level=#{character_current_activity_state - 4}&amount=#{users_wallet - 20}&extra=from_feeding&fed_state=#{character_current_fed_state + 20}&happiness=#{character_current_happiness + 4}"
        link_for_feeding_process_extra = "activity_require_level=#{character_current_activity_state - 5}&amount=#{users_wallet - 25}&extra=from_feeding&fed_state=#{character_current_fed_state + 25}&happiness=#{character_current_happiness + 5}"

        visit "/character/#{@char_of_feeding_page.id}/feeding"

        expect(page).to have_content('Name Of Character:')
        expect(page).to have_content(character_current_name)
        expect(page).to have_content('Activity require:')
        expect(page).to have_content(character_current_activity_state)
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_current_fed_state)
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_current_happiness)

        expect(page).to have_content(@user_feeding_page_wallet.amount)
        expect(@user_feeding_page_wallet.amount).to eq(100)

        page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?#{link_for_feeding_process_small}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?#{link_for_feeding_process_minor}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?#{link_for_feeding_process_normal}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?#{link_for_feeding_process_large}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process?#{link_for_feeding_process_extra}')]")

        page.should have_xpath("//a[contains(@href,'character/#{character_id}/feeding_process')]", :count => 5)

        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

      end

    end

    feature 'The current user is NOT the owner of the character' do

      before do
        @extra_user_feeding_page = User.create(name:'@xtra_user_feeding_page', email: 'extra_user_feeding_page@email.com', password:'password', password_confirmation:'password')
        @extra_char_feeding_page = Character.create(name:'extra_char_feeding_page',
                                                    user_id:@extra_user_feeding_page.id,
                                                    status:'alive',
                                                    age: 214,
                                                    fed_state:10,
                                                    activity_require_level:46,
                                                    happiness:31)
      end

      scenario 'Should return with en error message and redirected for characters page' do

        visit "/character/#{@extra_char_feeding_page.id}/feeding"

        current_path.should == characters_path
        expect(page).to have_content('That Character is not Yours!')

      end
    end
  end

  feature 'When the Character does NOT exist' do

    scenario 'Because dead' do

      @char_of_feeding_page.update_attributes(status:'dead')

      visit "/character/#{@char_of_feeding_page.id}/feeding"

      current_path.should == characters_path
      expect(page).to have_content('This Character is Dead already!')

    end

    feature 'Because never been created' do

      scenario 'Should return with en error message and redirected for characters page' do

        visit "/character/1234567/feeding"

        current_path.should == characters_path
        expect(page).to have_content('That Character is not exist!')

      end
    end
  end
end

