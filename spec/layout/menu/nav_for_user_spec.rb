require 'rails_helper'

RSpec.feature 'Menu for users' do

  before do
    @user_for_menu = User.create(name:'Test_user', email:'email@email.com', password:'password', password_confirmation:'password')
    @char_for_menu = Character.create(name:'@char_for_menu',
                                             user_id:1,
                                             status:'alive',
                                             age: 214,
                                             fed_state:80,
                                             activity_require_level:60,
                                             happiness:50)
  end

  scenario 'shows user details and actions' do

    visit '/'
    click_link 'log-in'

    fill_in 'user_email', with: 'email@email.com'
    fill_in 'user_password', with: 'password'

    click_button 'Log in'

    expect(page).to have_link('Sign Out')

    expect(page).to have_content(@user_for_menu.name)

  end

end