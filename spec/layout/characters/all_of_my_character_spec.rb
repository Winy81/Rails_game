require 'rails_helper'

RSpec.feature 'All of my character' do

  feature 'Has to turn up all of the Users Character'

  before do
    @user_all_of_my_c = User.create(name:'user_all_of_my_c', email: 'user_all_of_my_c@email.com', password:'password', password_confirmation:'password')
    login_as(@user_all_of_my_c)

    @character_2_of_user = Character.create(name:'Test_char_2_of_user', user_id:1, status:'dead')
    @character_3_of_user = Character.create(name:'Test_char_3_of_user', user_id:1, status:'dead')
  end

  scenario 'User has not character alive' do

    all_of_character_of_user_all_of_my_c = Character.where(user_id:1).count

    visit '/all_of_my_character'

    expect(page).to have_content('Current user_id:')
    expect(current_path).to eq(all_of_my_character_path)
    expect(page).to have_content(@user_all_of_my_c.name)
    expect(page).to have_content('Your characters history')
    expect(page).to have_content('Name of Character:', count: all_of_character_of_user_all_of_my_c)
    expect(page).to have_content('Was living:', count: all_of_character_of_user_all_of_my_c)
    expect(page).to have_content('Status:dead', count: all_of_character_of_user_all_of_my_c)
    expect(page).to have_content('Your characters history')
    expect(page).to have_link('Back to the Characters Page')

  end


  scenario 'User has character alive' do

    @character_1_of_user = Character.create(name:'Test_char_1_of_user', user_id:1, status:'alive')

    all_of_character_of_user_all_of_my_c = Character.where(user_id:1).count
    character_alive = Character.where(user_id:1, status:'alive').count

    visit '/all_of_my_character'

    expect(page).to have_content('Current user_id:')
    expect(current_path).to eq(all_of_my_character_path)
    expect(page).to have_link('Manage Character')
    expect(page).to have_content(@user_all_of_my_c.name)
    expect(page).to have_content('Your characters history')
    expect(page).to have_link('Manage Character')
    expect(page).to have_content('Status:alive', count: character_alive)
    expect(page).to have_content('Name of Character:', count: all_of_character_of_user_all_of_my_c)
    expect(page).to have_content('Was living:', count: all_of_character_of_user_all_of_my_c - character_alive)
    expect(page).to have_content('Status:dead', count: all_of_character_of_user_all_of_my_c - character_alive)
    expect(page).to have_content('Your characters history')
    expect(page).to have_link('Back to the Characters Page')

  end

end