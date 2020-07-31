require 'rails_helper'

RSpec.feature 'Playing process page' do

  before do
    @user_playing_process = User.create(name:'user_playing_process', email: 'user_playing_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_playing_process)
    @char_of_playing_proc = Character.create(name:'char_of_playing_proc',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:50,
                                             activity_require_level:50,
                                             happiness:95)
    @user_playing_process_wallet = Wallet.create(user_id:@user_playing_process.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )

  end

  feature 'When the page refreshed with new data (GET request)' do

    scenario 'Should be not proceed and redirected for character page' do

      character_id = @char_of_playing_proc.id
      increased_happiness = 3

      visit "/character/#{character_id}/playing_process?happiness=#{increased_happiness}&extra=from_playing"

      @char_of_playing_proc.happiness.should == 95
      current_path.should == character_path(@char_of_playing_proc)
      expect(page).to have_content("Oops, your character has not become Happy")
      expect(page).to have_content(@char_of_playing_proc.happiness)

    end
  end


  feature 'Should be proceed with POST request' do

    feature 'With overloaded values' do

      scenario 'Should be proceed until the min and redirected for character page with notice' do

        character_id = @char_of_playing_proc.id
        character_fed_state = @char_of_playing_proc.fed_state
        character_activity_require = @char_of_playing_proc.activity_require_level
        character_happiness = @char_of_playing_proc.happiness
        users_wallet = @user_playing_process_wallet.amount
        lose_able_feed_points = 25
        spendable_amount = 5
        spendable_activity_point = 5
        claim_able_happiness = 10

        visit "/character/#{character_id}/playing"

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/playing_process?activity_require_level=#{character_activity_require - spendable_activity_point}&amount=#{users_wallet - spendable_amount}&extra=from_playing&fed_state=#{character_fed_state - lose_able_feed_points}&happiness=#{character_happiness + claim_able_happiness}')]").click

        find_button('Claim').click

        current_path.should == character_path(@char_of_playing_proc)
        expect(page).to have_content("Your Character do not want to play more")
        expect(page).to have_content('Happiness:')
        expect(page).to have_content('100')
        Character.find_by(id:@char_of_playing_proc.id).happiness.should == 100

        expect(page).to have_content(@user_playing_process_wallet.amount)
        expect(@user_playing_process_wallet.amount).to eq(users_wallet)

      end
    end

    feature 'With too low sources' do

      before do
        @char_of_playing_proc.update_attributes(fed_state:50,activity_require_level:2)
      end

      feature 'When the activity require level is low' do

        scenario 'Should do not proceed and return with error message' do

          character_id = @char_of_playing_proc.id
          character_fed_state = @char_of_playing_proc.fed_state
          character_activity = @char_of_playing_proc.activity_require_level
          character_happiness = @char_of_playing_proc.happiness
          users_wallet = @user_playing_process_wallet.amount
          lose_able_feed_points = 25
          spendable_amount = 5
          spendable_activity_point = 5
          claim_able_happiness = 10

          visit "/character/#{character_id}/playing"

          find(:xpath, "//a[contains(@href,'/character/#{character_id}/playing_process?activity_require_level=#{character_activity - spendable_activity_point}&amount=#{users_wallet - spendable_amount}&extra=from_playing&fed_state=#{character_fed_state - lose_able_feed_points}&happiness=#{character_happiness + claim_able_happiness}')]").click

          current_path.should == character_path(@char_of_playing_proc)

          expect(page).to have_content('Your are too tired to move')

        end

      end

      feature 'When the gold is low' do

        before do
          @char_of_playing_proc.update_attributes(activity_require_level:25)
          @user_playing_process_wallet.update_attributes(amount:2)
        end

        scenario 'Should do not proceed and return with error message' do

          character_id = @char_of_playing_proc.id
          character_fed_state = @char_of_playing_proc.fed_state
          character_activity = @char_of_playing_proc.activity_require_level
          character_happiness = @char_of_playing_proc.happiness
          users_wallet = @user_playing_process_wallet.amount
          lose_able_feed_points = 25
          spendable_amount = 5
          spendable_activity_point = 5
          claim_able_happiness = 10

          visit "/character/#{character_id}/playing"

          find(:xpath, "//a[contains(@href,'/character/#{character_id}/playing_process?activity_require_level=#{character_activity - spendable_activity_point}&amount=#{users_wallet - spendable_amount}&extra=from_playing&fed_state=#{character_fed_state - lose_able_feed_points}&happiness=#{character_happiness + claim_able_happiness}')]").click

          current_path.should == character_path(@char_of_playing_proc)

          expect(page).to have_content('Your have not enough Gold for this action')

        end
      end

      feature 'When the fed_state is low' do

        before do
          @char_of_playing_proc.update_attributes(activity_require_level:25, fed_state:5)
          @user_playing_process_wallet.update_attributes(amount:25)
        end

        scenario 'Should do not proceed and return with error message' do

          character_id = @char_of_playing_proc.id
          character_fed_state = @char_of_playing_proc.fed_state
          character_activity = @char_of_playing_proc.activity_require_level
          character_happiness = @char_of_playing_proc.happiness
          users_wallet = @user_playing_process_wallet.amount
          lose_able_feed_points = 25
          spendable_amount = 5
          spendable_activity_point = 5
          claim_able_happiness = 10

          visit "/character/#{character_id}/playing"

          find(:xpath, "//a[contains(@href,'/character/#{character_id}/playing_process?activity_require_level=#{character_activity - spendable_activity_point}&amount=#{users_wallet - spendable_amount}&extra=from_playing&fed_state=#{character_fed_state - lose_able_feed_points}&happiness=#{character_happiness + claim_able_happiness}')]").click

          current_path.should == character_path(@char_of_playing_proc)

          expect(page).to have_content('Your are too hungry to move')
        end
      end
    end

    feature 'With acceptable increase' do

      scenario 'Should be turn up with page with claim-able details and process button' do

        current_character = Character.find_by(id:1)

        character_id = current_character.id
        character_fed_state = current_character.fed_state
        character_activity_require = current_character.activity_require_level
        character_happiness = current_character.happiness
        lose_able_feed_points = 10
        spendable_amount = 2
        spendable_activity_point = 2
        claim_able_happiness = 4
        users_wallet = @user_playing_process_wallet.amount

        visit "character/#{character_id}/playing"

        current_path.should == character_playing_path(current_character)

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/playing_process?activity_require_level=#{character_activity_require - spendable_activity_point}&amount=#{users_wallet - spendable_amount}&extra=from_playing&fed_state=#{character_fed_state - lose_able_feed_points}&happiness=#{character_happiness + claim_able_happiness}')]").click

        expect(page).to have_content('Activity Require')
        expect(page).to have_content(character_activity_require)
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_fed_state)
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_happiness)
        expect(page).to have_content("Lose-able: -#{lose_able_feed_points}")
        expect(page).to have_content("Lose-able: -#{spendable_activity_point}")
        expect(page).to have_content("Claim-able: #{claim_able_happiness}")
        expect(page).to have_content("Going to Cost: #{spendable_amount} Gold")

        find_button('Claim').click

        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

        current_path.should == character_path(current_character)

        expect(page).to have_content('Activity Require')
        expect(page).to have_content(character_activity_require - spendable_activity_point)
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_fed_state - lose_able_feed_points)
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_happiness + claim_able_happiness)


        updated_wallet = Wallet.find_by(user_id:@char_of_playing_proc.id).amount
        expect(page).to have_content(updated_wallet)
        expect(updated_wallet).to eq(users_wallet - spendable_amount)


      end
    end
  end
end