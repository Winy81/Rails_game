require 'rails_helper'

RSpec.feature 'Show characters without user logged in' do

  before do
    @character = Character.create(name:'Test_character', user_id:1)
    @character_2 = Character.create(name:'Test_character_2', user_id:2)
    @character_3 = Character.create(name:'Test_character_2', user_id:3)
    @characters = Character.all.count
  end

  scenario 'shows the oldest characters' do
    visit '/'

    expect(page).to have_content('sign up')
    expect(page).to have_content('log-in')

    expect(page).to have_content('Top Characters:')

    expect(page).to have_link(@character.name)
    expect(page).to have_content(@character.age)
    expect(page).to have_content(@character.status)

    expect(page).to have_link(@character_2.name)
    expect(page).to have_content(@character_2.age)
    expect(page).to have_content(@character_2.status)

    expect(page).to have_link(@character_3.name)
    expect(page).to have_content(@character_3.age)
    expect(page).to have_content(@character_3.status)

    expect(page).to have_content('Status', count: @characters)

  end

end