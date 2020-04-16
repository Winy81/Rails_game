require 'rails_helper'

RSpec.feature 'Feeding process page' do

  before do
    @user_feeding_process = User.create(name:'user_feeding_process', email: 'user_feeding_process@email.com', password:'password', password_confirmation:'password')
    login_as(@user_feeding_process)

    @char_of_feeding_proc = Character.create(name:'char_of_feeding_proc',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:10,
                                             activity_require_level:60,
                                             happiness:50)
  end

  feature 'When the page refreshed with new data (GET request)' do

    scenario 'Should be not proceed and redirected for character page' do

      character_id = @char_of_feeding_proc.id
      increased_fed_state = 20

      visit "/character/#{character_id}/feeding_process?extra=from_feeding&fed_state=#{increased_fed_state}"

      @char_of_feeding_proc.fed_state.should == 10
      current_path.should == character_path(@char_of_feeding_proc)
      expect(page).to have_content("Opps, your character couldn't finish the meal")
      expect(page).to have_content(@char_of_feeding_proc.fed_state)

    end
  end


  feature 'Should be proceed with POST request' do

    scenario 'Should be turn up with page with claim-able details and process button' do

    end

  end

end