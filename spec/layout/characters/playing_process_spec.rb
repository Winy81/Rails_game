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
                                              activity_require_level:5,
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
      expect(page).to have_content("Opps, your character has not become Happy")
      expect(page).to have_content(@char_of_playing_proc.happiness)

    end
  end


  feature 'Should be proceed with POST request' do

    feature 'With overloaded values' do

      scenario 'Should be proceed until the min and redirected for character page with notice' do

        character_id = @char_of_playing_proc.id
        character_happiness_state = @char_of_playing_proc.happiness
        users_wallet = @user_playing_process_wallet.amount

        visit "/character/#{character_id}/playing"

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/playing_process?extra=from_playing&happiness=#{character_happiness_state + 10}&amount=#{users_wallet - 5}')]").click

        find(:xpath, "//a[contains(@href,'/characters/#{character_id}?extra=from_playing_process&happiness=#{character_happiness_state + 10}&amount=#{users_wallet - 5}')]").click


        current_path.should == character_path(@char_of_playing_proc)
        expect(page).to have_content("Your Character do not want to play more")
        expect(page).to have_content('Happiness:')
        expect(page).to have_content('100')
        Character.find_by(id:@char_of_playing_proc.id).happiness.should == 100

        expect(page).to have_content(@user_playing_process_wallet.amount)
        expect(@user_playing_process_wallet.amount).to eq(users_wallet)

      end
    end

    feature 'With acceptable increase' do

      scenario 'Should be turn up with page with claim-able details and process button' do

        current_character = Character.find_by(id:1)

        character_id = current_character.id
        character_happiness_state = current_character.happiness
        claim_able_happiness_points = 4
        users_wallet = @user_playing_process_wallet.amount

        visit "character/#{character_id}/playing"

        current_path.should == character_playing_path(current_character)

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/playing_process?extra=from_playing&happiness=#{character_happiness_state + claim_able_happiness_points}&amount=#{users_wallet - 5}')]").click

        expect(page).to have_content('Happiness:')
        expect(page).to have_content('Fed State:')
        expect(page).to have_content(character_happiness_state)
        expect(page).to have_content('Claim-able:')
        expect(page).to have_content(claim_able_happiness_points)

        find(:xpath, "//a[contains(@href,'/characters/#{character_id}?extra=from_playing_process&happiness=#{character_happiness_state + claim_able_happiness_points}&amount=#{users_wallet - 5}')]").click
        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

        current_path.should == character_path(current_character)
        expect(page).to have_content('Happiness')
        expect(page).to have_content(character_happiness_state + claim_able_happiness_points)

        updated_wallet = Wallet.find_by(user_id:@user_playing_process.id).amount

        expect(page).to have_content(updated_wallet)

      end
    end
  end
end