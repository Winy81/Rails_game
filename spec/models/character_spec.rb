require 'rails_helper'

RSpec.describe Character, type: :model do

  before :each do
    @user = User.create(id:1, email: "test_user@email.com", name: "test_user", role: "user", password:'password')
    @character_1 = Character.create(name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 3, user_id: 1 )
  end

  context 'validations' do

    context 'built in validations' do

      let(:invalid_char_by_name) { Character.create(name:'character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', user_id: 2 )}

      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :fed_state }
      it { is_expected.to validate_presence_of :happiness }
      it { is_expected.to validate_presence_of :activity_require_level }
      it { is_expected.to validate_presence_of :status }

      it { is_expected.to validate_presence_of :user_id }

      it { should validate_length_of(:name).is_at_most(25).with_message('is too long (maximum is 25 characters)') }

      it 'required unique name' do

        expect(@character_1).to be_valid
        expect(invalid_char_by_name).not_to be_valid

      end
    end
  end

  describe '#age_order_filter' do

    before do
      @character_2 = Character.create(name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 1 )
    end

    it 'has to returned with all character in DESC order by age' do

      ordered_characters = Character.all.age_order_filter

      expect(ordered_characters.count).to eq(2)
      expect(ordered_characters.first.age).to eq(@character_2.age)
      expect(ordered_characters.last.age).to eq(@character_1.age)

    end
  end

  describe '#age_order_alive_filter' do

    before do
      @character_2 = Character.create(name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 1 )
      @dead_character = Character.create(name:'dead_character',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 10, user_id: 1)
    end

    it 'has to returned with all character in DESC order by age but dead character should not be included' do

      all_characters = Character.all
      ordered_characters = Character.all.age_order_alive_filter

      expect(all_characters.count).to eq(3)
      expect(ordered_characters.count).to eq(2)
      expect(ordered_characters.first.age).to eq(@character_2.age)
      expect(ordered_characters.last.age).to eq(@character_1.age)

    end
  end


  describe '#character_in_asc_id_order' do

    before do
      @character_2 = Character.create(name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 1 )
      @dead_character = Character.create(name:'dead_character',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 10, user_id: 1)
    end

    it 'has to returned with all character in ASC order by ID' do

      ordered_characters = Character.all.character_in_asc_id_order

      expect(ordered_characters.count).to eq(3)

      expect(ordered_characters.first.id).to be < (ordered_characters.second.id)
      expect(ordered_characters.first.id).to be < (ordered_characters.last.id)
    end
  end

  describe '#characters_history_order_logic' do

    before do
      @updated_character_1 = @character_1.update(id:100)
      @dead_character = Character.create(name:'dead_character_1',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 10, user_id: 1)
      @dead_character_2 = Character.create(name:'dead_character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 20, user_id: 1)
    end

    it 'has to returned with all character the with "alive" first and DESC order by ID' do

      ordered_characters = Character.all.characters_history_order_logic

      expect(ordered_characters.count).to eq(3)

      expect(ordered_characters.first.status).to eq('alive')
      expect(ordered_characters.second.id).to be > (ordered_characters.last.id)
    end
  end

  describe '#limited_desc_ordered_characters' do

    before do
      15.times do |character |
        Character.create(name:"#{character}_of_test",
                         user_id:1,
                         fed_state: 10,
                         happiness: 10,
                         age: rand(10..200),
                         activity_require_level:10,
                         status:'dead',
                         died_on: Time.now
        )
      end
    end

    it 'has to returned with all character in DESC order by age with limit 10' do

      all_characters = Character.all
      ordered_characters = Character.all.limited_desc_ordered_characters

      expect(all_characters.count).to eq(16)
      expect(ordered_characters.count).to eq(10)
      expect(ordered_characters.first.age).to be > (ordered_characters.second.age)
      expect(ordered_characters.first.age).to be > (ordered_characters.last.age)

    end
  end

  describe '#owner_of_character' do

    it 'has to returned with name owner of character' do

      filtered = @character_1.owner_of_character

      expect(filtered).to eq("test_user")

    end
  end

  describe '#active_living_characters' do

    before do
      @character_2 = Character.create(name:'character_2',fed_state: 10,happiness:10, activity_require_level: 10, status:'alive', age: 5, user_id: 1 )
      @dead_character = Character.create(name:'dead_character',fed_state: 10,happiness:10, activity_require_level: 10, status:'dead', age: 10, user_id: 1)
    end

    it 'has to returned with all active living character' do

      all_characters = Character.all
      ordered_characters = Character.active_living_characters

      expect(all_characters.count).to eq(3)

      expect(ordered_characters.count).to eq(2)

      ordered_characters.each { |character| expect(character.status).to eq('alive')
                                            expect(character.hibernated).to eq(false)
                                            expect(character.manualy_hibernated).to eq(false)}

    end
  end

  describe '#character_is_dying' do

    it 'the active character has to be updated for status: "dead" and died_on: "Now"' do

      process_time = Timecop.freeze(Time.now)

      dying_character = Character.find_by(id:1)

      dying_character.character_is_dying

      dead_character = Character.find_by(id:1)

      expect(dead_character.status).to eq('dead')
      expect(dead_character.died_on).to eq(process_time)

      Timecop.return

    end
  end
end
