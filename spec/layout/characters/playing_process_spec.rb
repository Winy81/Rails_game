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
                                              happiness:50)
  end

  feature 'When the page refreshed with new data (GET request)' do

    scenario 'Should be not proceed and redirected for character page' do

      character_id = @char_of_playing_proc.id
      increased_happiness = 5

      visit "/character/#{character_id}/playing_process?happiness=#{increased_happiness}&extra=from_playing"

      @char_of_playing_proc.happiness.should == 50
      current_path.should == character_path(@char_of_playing_proc)
      expect(page).to have_content("Opps, your character has not become Happy")
      expect(page).to have_content(@char_of_playing_proc.happiness)

    end
  end


  feature 'Should be proceed with POST request' do

    feature 'With overloaded values' do

      scenario 'Should be proceed until the min and redirected for character page with notice' do


      end
    end

    feature 'With acceptable increase' do

      scenario 'Should be turn up with page with claim-able details and process button' do

      end
    end
  end
end