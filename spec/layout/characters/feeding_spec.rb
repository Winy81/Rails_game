require 'rails_helper'

RSpec.feature 'Feeding page' do

  before do
    @user_feeding_page = User.create(name:'user_feeding_page', email: 'user_feeding_page@email.com', password:'password', password_confirmation:'password')
    login_as(@user_feeding_page)

    @char_of_feeding_page = Character.create(name:'char_feeding_page',
                                    user_id:1,
                                    status:'alive',
                                    age: 214,
                                    fed_state:56,
                                    activity_require_level:46,
                                    happiness:31)
  end

  scenario 'Should turn up with list of food' do

    visit "/character/#{@char_of_feeding_page.id}/feeding"

  end
end