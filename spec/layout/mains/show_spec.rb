require 'rails_helper'

include DateTransformHelper

RSpec.feature 'Show characters without user logged in' do

  before do
    @user = User.create(name:'Test_user', email:'email@email.com', password:'password')
    @character = Character.create(name:'Test_character', user_id:@user.id)
    @number_of_characters = Character.where(user_id:@user.id)
  end

  scenario 'shows character details' do
    visit '/'
    click_link 'Test_character'

    expect(page).to have_content('sign up')
    expect(page).to have_content('log-in')

    expect(page).to have_content('Details of Character:')
    expect(page).to have_content(@character.name)
    expect(page).to have_content(@character.age)
    expect(page).to have_content(@character.status)

    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.date_view_optimizer(@user.created_at))

    expect(@number_of_characters.count).to eq(1)

    expect(page).to have_link('Back to the Main Page')
  end

end