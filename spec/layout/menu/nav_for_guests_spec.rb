require 'rails_helper'

RSpec.feature 'Menu for guests' do

  scenario 'shows user details and actions' do

    visit '/'


    expect(page).to have_link('Sign in')
    expect(page).to have_link('Log in')

  end

end