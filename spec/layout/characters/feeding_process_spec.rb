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

        visit "/character/#{character_id}/feeding"

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_fed_state + 25}')]").click

        find(:xpath, "//a[contains(@href,'/characters/#{character_id}?extra=from_feeding_process&fed_state=#{character_fed_state + 25}')]").click


        current_path.should == character_path(@char_of_feeding_proc)
        expect(page).to have_content("Your are full")
        expect(page).to have_content('Fed State:')
        expect(page).to have_content('100')
        Character.find_by(id:@char_of_feeding_proc.id).fed_state.should == 100

      end
    end

    feature 'With acceptable increase' do

      scenario 'Should be turn up with page with claim-able details and process button' do

        current_character = Character.find_by(id:1)

        character_id = current_character.id
        character_current_fed_state = current_character.fed_state
        claim_able_feed_points = 5

        visit "character/#{character_id}/feeding"

        current_path.should == character_feeding_path(current_character)

        find(:xpath, "//a[contains(@href,'/character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{character_current_fed_state + claim_able_feed_points}')]").click

        expect(page).to have_content('Fed State:')
        expect(page).to have_content('Happiness:')
        expect(page).to have_content(character_current_fed_state)
        expect(page).to have_content('Claim-able:')
        expect(page).to have_content(claim_able_feed_points)

        find(:xpath, "//a[contains(@href,'/characters/#{character_id}?extra=from_feeding_process&fed_state=#{character_current_fed_state + claim_able_feed_points}')]")
        page.all(:xpath, "//a[contains(@href,'characters/#{character_id}')]")

      end
    end
  end
end