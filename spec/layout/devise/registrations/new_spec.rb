require 'rails_helper'

RSpec.feature 'Create new user page' do

  scenario 'Should do not create user without all data' do

    visit '/users/sign_up'

    expect(page).to have_content('Sign up')

    fill_in 'user_email', with: 'test_user_reg@email.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'

    click_button 'Sign up'

    expect(page).to have_content("Name can't be blank")

    expect(current_path).to eq(user_registration_path)
  end

  scenario 'Should do create user if all data provided include name' do

    visit '/users/sign_up'

    expect(page).to have_content('Sign up')

    fill_in 'user_name', with: 'test_user_reg'
    fill_in 'user_email', with: 'test_user_reg@email.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'

    click_button 'Sign up'

    user = User.find_by(name:'test_user_reg')

    expect(user.name).to eq('test_user_reg')
    expect(user.email).to eq('test_user_reg@email.com')
    expect(user.has_character).to eq(false)

    expect(page).to have_content('Welcome! You have signed up successfully.')

    expect(current_path).to eq(characters_path)

    wallet_of_user = Wallet.find_by(id:user.id)
    expect(wallet_of_user).to eq(100)

  end

end