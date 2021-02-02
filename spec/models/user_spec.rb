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

end