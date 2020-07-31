require 'rails_helper'

RSpec.feature 'Activity process page' do

  before do
    @user_activity_process = User.create(name:'user_activity_process', email: 'user_activity_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_activity_process)
    @char_of_activity_proc = Character.create(name:'char_activity_process',
                                              user_id:1,
                                              status:'alive',
                                              age: 214,
                                              fed_state:50,
                                              activity_require_level:5,
                                              happiness:50)

    @user_activity_process_wallet = Wallet.create(user_id:@user_activity_process.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )

  end

  feature 'When the page refreshed with new data (GET request)' do

    scenario 'Should be not proceed and redirected for character page' do

      character_id = @char_of_activity_proc.id
      decrease_activity_state = -3

      visit "/character/#{character_id}/activity_process?activity_require_level=#{decrease_activity_state}&extra=from_activity"

      @char_of_activity_proc.activity_require_level.should == 5
      current_path.should == character_path(@char_of_activity_proc)
      expect(page).to have_content('Oops, your character has could not finish the training')
      expect(page).to have_content(@char_of_activity_proc.activity_require_level)

    end
  end


  feature 'Should be proceed with POST request' do

    feature 'With low sources values' do

      feature 'With too low activity'  do

        scenario 'Should redirected for character page with notice'do

          character_id = @char_of_activity_proc.id
          character_fed_state = @char_of_activity_proc.fed_state
          character_activity = @char_of_activity_proc.activity_require_level
          character_happiness = @char_of_activity_proc.happiness
          users_wallet = @user_activity_process_wallet.amount
          get_amount = 10

          visit "/character/#{character_id}/activity"

          find(:xpath, "//a[contains(@href,'/character/#{character_id}/activity_process?activity_require_level=#{character_activity - 10}&amount=#{users_wallet + get_amount}&extra=from_activity&fed_state=#{character_fed_state - 5}&happiness=#{character_happiness + 5}')]").click

          current_path.should == character_path(@char_of_activity_proc)
          expect(page).to have_content('Your are too tired to move')
          expect(page).to have_content('Activity')
          expect(page).to have_content(character_activity)
          Character.find_by(id:@char_of_activity_proc.id).activity_require_level.should == character_activity

          expect(page).to have_content(@user_activity_process_wallet.amount)
          expect(@user_activity_process_wallet.amount).to eq(users_wallet)

        end

        feature 'With too low fed_state' do

          before do
            @char_of_activity_proc.update_attributes(fed_state:2,activity_require_level:50)
          end

          scenario 'Should redirected for character page with notice' do

            character_id = @char_of_activity_proc.id
            character_fed_state = @char_of_activity_proc.fed_state
            character_activity = @char_of_activity_proc.activity_require_level
            character_happiness = @char_of_activity_proc.happiness
            users_wallet = @user_activity_process_wallet.amount
            get_amount = 10

            visit "/character/#{character_id}/activity"

            find(:xpath, "//a[contains(@href,'/character/#{character_id}/activity_process?activity_require_level=#{character_activity - 10}&amount=#{users_wallet + get_amount}&extra=from_activity&fed_state=#{character_fed_state - 5}&happiness=#{character_happiness + 5}')]").click

            current_path.should == character_path(@char_of_activity_proc)
            expect(page).to have_content('Your are too hungry to move')
            expect(page).to have_content('Activity')
            expect(page).to have_content(character_activity)
            Character.find_by(id:@char_of_activity_proc.id).activity_require_level.should == character_activity

            expect(page).to have_content(@user_activity_process_wallet.amount)
            expect(@user_activity_process_wallet.amount).to eq(users_wallet)

          end
        end
      end
    end

    feature 'With acceptable increase' do

      scenario 'Should be turn up with page with claim-able details and process button' do

        current_character = Character.find_by(name:'char_activity_process')

        character_id = current_character.id
        character_fed_state = current_character.fed_state
        character_activity_require = current_character.activity_require_level
        character_happiness = current_character.happiness
        spendable_feed_points = -1
        claimable_amount = 2
        spendable_activity_points = -2
        claimable_happiness = 1
        users_wallet = @user_activity_process_wallet.amount

        visit "character/#{character_id}/activity"

        current_path.should == character_activity_path(current_character)

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/activity_process?activity_require_level=#{character_activity_require + spendable_activity_points}&amount=#{users_wallet + claimable_amount}&extra=from_activity&fed_state=#{character_fed_state + spendable_feed_points}&happiness=#{character_happiness + claimable_happiness}')]").click

        expect(page).to have_content('Activity Require')
        expect(page).to have_content(character_activity_require)
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_fed_state)
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_happiness)
        expect(page).to have_content("Lose-able: #{spendable_feed_points}")
        expect(page).to have_content("Lose-able: #{spendable_activity_points}")
        expect(page).to have_content("Claim-able: #{claimable_happiness}")
        expect(page).to have_content("Going to Get: #{claimable_amount} Gold")

        #page.evaluate_script("$('#claim_button').removeAttr('disabled')")
        find_button('Claim').click

        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

        expect(page).to have_content('Activity Require')
        expect(page).to have_content(character_activity_require + spendable_activity_points)
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_fed_state + spendable_feed_points)
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_happiness + claimable_happiness)


        updated_wallet = Wallet.find_by(user_id:@user_activity_process.id).amount
        expect(page).to have_content(updated_wallet)
        expect(updated_wallet).to eq(users_wallet + claimable_amount)

      end
    end
  end
end