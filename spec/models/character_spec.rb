require 'rails_helper'

RSpec.describe Character, type: :model do

  context 'validations' do

    context 'built in validations' do

      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :fed_state }
      it { is_expected.to validate_presence_of :happiness }
      it { is_expected.to validate_presence_of :activity_require_level }
      it { is_expected.to validate_presence_of :status }

      it { is_expected.to validate_presence_of :user_id }

    end

  end
end