require 'rails_helper'

RSpec.feature 'Activity page' do

  before do
    @user_activity_page = User.create(name:'user_activity_page', email: 'user_activity_page@email.com', password:'password', password_confirmation:'password')
    login_as(@user_activity_page)

    @user_activity_page = Character.create(name:'char_activity_page',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:10,
                                             activity_require_level:46,
                                             happiness:31)
  end

  scenario 'Should turn up with list of activities' do

  end

end