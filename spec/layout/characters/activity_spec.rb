require 'rails_helper'

RSpec.feature 'Activity page' do

  before do
    @user_activity_page = User.create(name:'user_activity_page', email: 'user_activity_page@email.com', password:'password', password_confirmation:'password')
    login_as(@user_activity_page)

    @character_activity_page = Character.create(name:'char_activity_page',
                                                user_id:@user_activity_page.id,
                                                status:'alive',
                                                age: 214,
                                                fed_state:10,
                                                activity_require_level:46,
                                                happiness:31)

    @user_activity_page_wallet = Wallet.create(user_id:@user_activity_page.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )

  end

  feature 'When the Character exist' do

    feature 'The current user is the owner of the character' do

      scenario 'Should turn up with list of actions with activity main action' do

        character_id = @user_activity_page.id
        character_current_activity_state = @character_activity_page.activity_require_level
        character_current_fed_state = @character_activity_page.fed_state
        character_current_happiness = @character_activity_page.happiness
        character_current_name = @character_activity_page.name
        users_wallet = @user_activity_page_wallet.amount

        link_for_activity_process_minor = "activity_require_level=#{character_current_activity_state - 2}&amount=#{users_wallet + 2}&extra=from_activity&fed_state=#{character_current_fed_state - 1}&happiness=#{character_current_happiness + 1}"
        link_for_activity_process_small = "activity_require_level=#{character_current_activity_state - 4}&amount=#{users_wallet + 4}&extra=from_activity&fed_state=#{character_current_fed_state - 2}&happiness=#{character_current_happiness + 2}"
        link_for_activity_process_normal = "activity_require_level=#{character_current_activity_state - 6}&amount=#{users_wallet + 6}&extra=from_activity&fed_state=#{character_current_fed_state - 3}&happiness=#{character_current_happiness + 3}"
        link_for_activity_process_large = "activity_require_level=#{character_current_activity_state - 8}&amount=#{users_wallet + 8}&extra=from_activity&fed_state=#{character_current_fed_state - 4}&happiness=#{character_current_happiness + 4}"
        link_for_activity_process_extra = "activity_require_level=#{character_current_activity_state - 10}&amount=#{users_wallet + 10}&extra=from_activity&fed_state=#{character_current_fed_state - 5}&happiness=#{character_current_happiness + 5}"


        visit "/character/#{@character_activity_page.id}/activity"

        expect(page).to have_content('Name Of Character:')
        expect(page).to have_content(character_current_name)
        expect(page).to have_content('Activity require:')
        expect(page).to have_content(character_current_activity_state)
        expect(page).to have_content('Fed State: ')
        expect(page).to have_content(character_current_fed_state)
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_current_happiness)

        expect(page).to have_content(@user_activity_page_wallet.amount)
        expect(@user_activity_page_wallet.amount).to eq(100)

        page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?#{link_for_activity_process_minor}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?#{link_for_activity_process_small}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?#{link_for_activity_process_normal}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?#{link_for_activity_process_large}')]")
        page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process?#{link_for_activity_process_extra}')]")

        page.should have_xpath("//a[contains(@href,'character/#{character_id}/activity_process')]", :count => 5)

        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

      end
    end

    feature 'The current user is NOT the owner of the character' do

      before do
        @extra_user_activity_page = User.create(name:'extra_user_activity_page', email: 'extra_user_activity_page@email.com', password:'password', password_confirmation:'password')
        @extra_char_activity_page = Character.create(name:'extra_char_activity_page',
                                                     user_id:@extra_user_activity_page.id,
                                                     status:'alive',
                                                     age: 214,
                                                     fed_state:10,
                                                     activity_require_level:46,
                                                     happiness:31)
      end

      scenario 'Should return with en error message and redirected for characters page' do

        visit "/character/#{@extra_char_activity_page.id}/activity"

        current_path.should == characters_path
        expect(page).to have_content('That Character is not Yours!')

      end
    end
  end

  feature 'When the Character does NOT exist' do

    scenario 'Because dead' do

      @character_activity_page.update_attributes(status:'dead')

      visit "/character/#{@character_activity_page.id}/activity"

      current_path.should == characters_path
      expect(page).to have_content('This Character is Dead already!')

    end

    feature 'Because never been created' do

      scenario 'Should return with en error message and redirected for characters page' do

        visit "/character/1234567//activity"

        current_path.should == characters_path
        expect(page).to have_content('That Character is not exist!')

      end
    end

  end
end