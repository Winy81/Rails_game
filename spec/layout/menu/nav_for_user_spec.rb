require 'rails_helper'

RSpec.feature 'Menu for users' do

  before do
    @user = User.create(name:'Test_user', email:'email@email.com', password:'password')
  end

  scenario 'shows user details and actions' do

    visit '/'
    click_link 'log-in'

    fill_in 'user_email', with: 'email@email.com'
    fill_in 'user_password', with: 'password'

    click_button 'Log in'

    expect(page).to have_link('Sign Out')

    expect(page).to have_content(@user.name)

  end

end