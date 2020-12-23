require 'rails_helper'

RSpec.describe Event, type: :model do

  context 'validations' do

      it { is_expected.to validate_presence_of :event_id }
      it { is_expected.to validate_presence_of :event_name }
      it { is_expected.to validate_presence_of :description }

  end
end
