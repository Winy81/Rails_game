require 'rails_helper'

RSpec.feature 'Characters history page' do

  before do
    @user_leaderb = User.create(name:'@user_leaderb', email: '@user_leaderb@email.com', password:'password', password_confirmation:'password')

    5.times do |user|
      current_user = User.create(email:"Dummy_#{user}@email.com",
                                 password: "password",
                                 password_confirmation: "password",
                                 name: "Dummy_user_#{user}")
      3.times do |character |
        Character.create(name:"#{character}_of_#{current_user.name}",
                         user_id:"#{current_user.id}",
                         fed_state: rand(30..60),
                         happiness: rand(30..60),
                         age: rand(10..200),
                         activity_require_level:rand(30..60),
                         status:'dead',
                         died_on: Time.now
        )
      end
    end
  end

  feature 'Without logged in user' do

    scenario 'Should turn up with all of the character and link for Main#index' do

      number_of_character = Character.all.count

      visit '/leaderboard'

      expect(page).to have_content('LeaderBoard')
      expect(page).to have_content('Name:', count: number_of_character)
      #15 character + back
      page.should have_xpath("//a[contains(@href,'mains')]", :count => number_of_character + 1)

    end

  end

  feature 'With User who logged in' do

    scenario 'Should turn up with all of the character and link for Character#index' do

      login_as(@user_leaderb)

      number_of_character = Character.all.count

      visit '/leaderboard'

      expect(page).to have_content('LeaderBoard')
      expect(page).to have_content('Name:', count: number_of_character)
      #15 character
      page.should have_xpath("//a[contains(@href,'character_info')]", :count => number_of_character)

    end

  end

end