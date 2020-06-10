require 'rails_helper'

RSpec.feature 'Feeding process page' do

  before do
    @user_feeding_process = User.create(name:'user_feeding_process', email: 'user_feeding_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_feeding_process)
    @char_of_feeding_proc = Character.create(name:'char_of_feeding_proc',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:80,
                                             activity_require_level:60,
                                             happiness:50)
    @user_feeding_process_wallet = Wallet.create(user_id:@user_feeding_process.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )
  end

  feature 'When the page refreshed with new data (GET request)' do

    scenario 'Should be not proceed and redirected for character page' do

      character_id = @char_of_feeding_proc.id
      increased_fed_state = 15

      visit "/character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{increased_fed_state}"

      @char_of_feeding_proc.fed_state.should == 80
      current_path.should == character_path(@char_of_feeding_proc)
      expect(page).to have_content("Opps, your character couldn't finish the meal")
      expect(page).to have_content(@char_of_feeding_proc.fed_state)

    end
  end


  feature 'Should be proceed with POST request' do

    feature 'With overloaded values' do

      scenario 'Should be proceed until the max and redirected for character page with notice' do

        character_id = @char_of_feeding_proc.id
        character_fed_state = @char_of_feeding_proc.fed_state
        users_wallet = @user_feeding_process_wallet.amount
        lost_amount = 15

        visit "/character/#{character_id}/feeding"

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/feeding_process?amount=#{users_wallet - lost_amount}&extra=from_feeding&fed_state=#{character_fed_state + 25}')]").click

        find(:xpath, "//a[contains(@href,'/characters/#{character_id}?amount=#{users_wallet - lost_amount}&extra=from_feeding_process&fed_state=#{character_fed_state + 25}')]").click


        current_path.should == character_path(@char_of_feeding_proc)
        expect(page).to have_content("Your are full")
        expect(page).to have_content('Fed State:')
        expect(page).to have_content('100')
        Character.find_by(id:@char_of_feeding_proc.id).fed_state.should == 100

        expect(page).to have_content(@user_feeding_process_wallet.amount)
        expect(@user_feeding_process_wallet.amount).to eq(users_wallet)

      end
    end

    feature 'With acceptable increase' do

      scenario 'Should be turn up with page with claim-able details and process button' do

        current_character = Character.find_by(id:1)

        character_id = current_character.id
        character_current_fed_state = current_character.fed_state
        claim_able_feed_points = 5
        lost_amount = 3
        users_wallet = @user_feeding_process_wallet.amount

        visit "character/#{character_id}/feeding"

        current_path.should == character_feeding_path(current_character)

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/feeding_process?amount=#{users_wallet - lost_amount}&extra=from_feeding&fed_state=#{character_current_fed_state + claim_able_feed_points}')]").click

        expect(page).to have_content('Fed State:')
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_current_fed_state)
        expect(page).to have_content('Claim-able:')
        expect(page).to have_content(claim_able_feed_points)
        expect(page).to have_content("Going to Cost: #{lost_amount} Gold")

        find(:xpath, "//a[contains(@href,'/characters/#{character_id}?amount=#{users_wallet - lost_amount}&extra=from_feeding_process&fed_state=#{character_current_fed_state + claim_able_feed_points}')]").click
        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

        current_path.should == character_path(current_character)
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_current_fed_state + claim_able_feed_points)

        updated_wallet = Wallet.find_by(user_id:@user_feeding_process.id).amount

        expect(page).to have_content(updated_wallet)
        expect(updated_wallet).to eq(users_wallet - lost_amount)

      end
    end
  end
end