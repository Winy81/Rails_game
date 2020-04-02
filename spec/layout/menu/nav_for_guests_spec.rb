require 'rails_helper'

RSpec.feature 'Menu for guests' do

  scenario 'shows user details and actions' do

    visit '/'


    expect(page).to have_link('sign up')
    expect(page).to have_link('log-in')

  end

end