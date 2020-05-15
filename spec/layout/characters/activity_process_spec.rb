require 'rails_helper'

RSpec.feature 'Feeding process page' do

  before do
    @user_activity_process = User.create(name:'user_activity_process', email: 'user_activity_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_activity_process)
    @char_of_activity_proc = Character.create(name:'char_activity_process',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:50,
                                             activity_require_level:80,
                                             happiness:50)
  end

  feature 'When the page refreshed with new data (GET request)' do

    scenario 'Should be not proceed and redirected for character page' do

      character_id = @char_of_activity_proc.id
      increased_activity_state = 15

      visit "/character/#{character_id}/activity_process?activity_require_level=#{increased_activity_state}&extra=from_activity"

      @char_of_activity_proc.activity_require_level.should == 80
      current_path.should == character_path(@char_of_activity_proc)
      expect(page).to have_content("Opps, your character couldn't finish the training")
      expect(page).to have_content(@char_of_activity_proc.activity_require_level)

    end
  end


  feature 'Should be proceed with POST request' do

    feature 'With overloaded values' do

      scenario 'Should be proceed until the max and redirected for character page with notice' do


      end
    end

    feature 'With acceptable increase' do

      scenario 'Should be turn up with page with claim-able details and process button' do


      end
    end
  end
end