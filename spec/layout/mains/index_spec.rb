require 'rails_helper'

RSpec.feature 'Show characters without user logged in' do

  before do
    @character = Character.create(name:'Test_character', user_id:1)
    @character_2 = Character.create(name:'Test_character_2', user_id:2)
    @character_3 = Character.create(name:'Test_character_3', user_id:3)
  end

  scenario 'shows the oldest characters' do
    number_of_characters = Character.all.count

    visit '/'

    expect(page).to have_link('Sign in')
    expect(page).to have_link('Log in')

    expect(page).to have_content('LeaderBoard:')

    expect(page).to have_content(@character.age)
    expect(page).to have_content(@character.status)

    expect(page).to have_content(@character_2.age)
    expect(page).to have_content(@character_2.status)

    expect(page).to have_content(@character_3.age)
    expect(page).to have_content(@character_3.status)

    #status because that countable
    expect(page).to have_content('Status', count: @characters)

    page.should have_xpath("//a[contains(@href,'mains')]", :count => number_of_characters)

  end

end