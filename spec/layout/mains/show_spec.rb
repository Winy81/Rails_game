require 'rails_helper'

include DateTransformHelper

RSpec.feature 'Show characters without user logged in' do

  before do
    @user_main_show = User.create!(name:'user_main_show', email:'user_main_show@email.com', password:'password', password_confirmation:'password')
    @character_main_show = Character.create(name:'character_main_show', user_id:@user_main_show.id)
    @user_main_show_wallet = Wallet.create(user_id:@user_main_show.id, amount: WalletServices::WalletProcessor::STARTER_AMOUNT )
    @number_of_characters = Character.where(user_id:@user_main_show.id)
  end

  feature 'shows character details' do

    before do
      @name_of_character = @character_main_show.name
      @age_of_character = @character_main_show.age
      @status_of_character = @character_main_show.status

      @name_of_user = @user_main_show.name
      @user_created_date = @user_main_show.date_view_optimizer(@user_main_show.created_at)
    end

    scenario 'with quest user' do

      visit '/mains/1'

      expect(page).to have_link('Sign in')
      expect(page).to have_link('Log in')

      expect(page).to have_content('Details of Character:')
      expect(page).to have_content(@name_of_character)
      expect(page).to have_content(@age_of_character)
      expect(page).to have_content(@status_of_character)

      expect(page).to have_content(@name_of_user)
      expect(page).to have_content(@user_created_date)

      expect(@number_of_characters.count).to eq(1)

      expect(page).not_to have_content(@user_main_show_wallet.amount)

      page.should have_xpath("//a[contains(@href,'mains')]", :count => 1)

    end

    scenario 'with user' do

      login_as(@user_main_show)

      visit '/mains/1'

      expect(page).to have_link('Sign Out')

      expect(page).to have_content(@name_of_character)
      expect(page).to have_content(@age_of_character)
      expect(page).to have_content(@status_of_character)

      expect(page).to have_content(@name_of_user)
      expect(page).to have_content(@user_created_date)

      expect(@number_of_characters.count).to eq(1)

      expect(page).to have_content(@user_main_show_wallet.amount)
      expect(@user_main_show_wallet.amount).to eq(100)

      page.should have_xpath("//a[contains(@href,'characters')]", :count => 1)

    end
  end
end