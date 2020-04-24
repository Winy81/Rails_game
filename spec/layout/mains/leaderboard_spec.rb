require 'rails_helper'

RSpec.feature 'Characters history page' do

  before do
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
      
    end

  end

  feature 'With User who logged in' do

    scenario 'Should turn up with all of the character and link for Character#index' do

    end

  end

end