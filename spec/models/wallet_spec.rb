require 'rails_helper'

RSpec.describe Wallet, type: :model do

  describe 'validations' do

    describe 'built in validations' do

      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_presence_of :user_id }
      it { is_expected.to validate_numericality_of(:amount).only_integer  }

    end
  end
end
