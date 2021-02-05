require 'rails_helper'

include User::Role

RSpec.describe User, type: :model do

  describe 'validations' do

    describe 'built in validations' do

      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :role }
      it do
        should validate_inclusion_of(:role).in_array(ALL)
      end

    end
  end

  describe 'associations' do

    it { should have_many(:characters) }
    it { should have_one(:wallet) }

  end

  describe '#users_in_asc_id_order' do

    before do
      @user = User.create(id:1, email: "test_user@email.com", name: "test_user", role: "user", password:'password')
      @user2 = User.create(id:2, email: "test_user2@email.com", name: "test_user2", role: "user", password:'password')
    end

    it 'should return with all users in ASC ordered ID' do

      all_users = User.all
      ordered_users = User.users_in_asc_id_order

      expect(all_users.count).to eq(2)
      expect(all_users.count).to eq(ordered_users.count)

      expect(ordered_users.first.id).to eq(1)
      expect(ordered_users.last.id).to eq(2)
    end

  end

  describe '#budget' do

    before do
      @user = User.create(id:1, email: "test_user@email.com", name: "test_user", role: "user", password:'password')
      @users_wallet = Wallet.create(user_id: 1, amount:100)
    end

    it 'should return with a users budget' do

      users_budget = @user.budget

      expect(users_budget).to eq(100)

    end

  end

end