require 'rails_helper'

RSpec.describe Character, type: :model do

  context 'validations' do

    context 'built in validations' do

      let(:user) { User.create(id:1, email: "test_user@email.com", name: "test_user", role: "user") }
      let(:character_1) { Character.create(name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', user_id: 1 )}
      let(:invalid_char_by_name) { Character.create(name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', user_id: 2 )}

      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :fed_state }
      it { is_expected.to validate_presence_of :happiness }
      it { is_expected.to validate_presence_of :activity_require_level }
      it { is_expected.to validate_presence_of :status }

      it { is_expected.to validate_presence_of :user_id }

      it { should validate_length_of(:name).is_at_most(25).with_message('is too long (maximum is 25 characters)') }

        it 'required unique name' do

          expect(character_1).to be_valid
          expect(invalid_char_by_name).not_to be_valid

        end
    end




  end
end