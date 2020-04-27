require 'rails_helper'

include DateTransformHelper

RSpec.feature 'Show characters without user logged in' do

  before do
    @user_main_show = User.create!(name:'user_main_show', email:'user_main_show@email.com', password:'password', password_confirmation:'password')
    @character_main_show = Character.create(name:'character_main_show', user_id:@user_main_show.id)
    @number_of_characters = Character.where(user_id:@user_main_show.id)
  end

  scenario 'shows character details' do
    visit '/mains/1'


    expect(page).to have_link('Sign in')
    expect(page).to have_link('Log in')

    expect(page).to have_content('Details of Character:')
    expect(page).to have_content(@character_main_show.name)
    expect(page).to have_content(@character_main_show.age)
    expect(page).to have_content(@character_main_show.status)

    expect(page).to have_content(@user_main_show.name)
    expect(page).to have_content(@user_main_show.date_view_optimizer(@user_main_show.created_at))

    expect(@number_of_characters.count).to eq(1)

    expect(page).to have_link('Back to the Main Page')
  end

end