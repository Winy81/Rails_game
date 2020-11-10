module Services
  module SearchEngine
    class Search

      include ActiveModel::AttributeMethods

      module UserRelatedFilters
        VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
        ONLY_NUMBER = /\A\d+\Z/
        ROLES = User::Role::ALL
        ACTIVE_STATUS = ['active', 'inactive']
      end

      module CharactersRelatedFilters
        ONLY_NUMBER = UserRelatedFilters::ONLY_NUMBER
        CHARACTER_STATUS = ['dead', 'alive']
      end

      def initialize(data,source)
        @data = data
        @source = source
      end

      def response
        if @source == "Search User"
          Services::SearchEngine::Account::AccountSearch.new(@data).return_data
        elsif @source == "Search Character"
          Services::SearchEngine::Character::CharacterSearch.new(@data).return_data
        end
      end

      private

      def user_fetch_by_id(id)
        User.where(id:id.to_i)
      end

      def user_fetch_by_email(email)
        User.where(email:email)
      end

      def user_fetch_by_role(role)
        User.where(role:role)
      end

      def user_fetch_by_activity(activity_status)
        activity_status == 'active' ? User.where(has_character:true) : User.where(has_character:false)
      end

      def user_fetch_by_name(name)
        User.where("name LIKE ?", "%#{name}%")
      end

      def character_fetch_by_id_or_age(number)
        ::Character.where(id:number.to_i) + ::Character.where(age:number.to_i)
      end

      def character_fetch_by_status(status)
        ::Character.where(status:status)
      end

      def character_fetch_by_name(name)
        ::Character.where("name LIKE ?", "%#{name}%")
      end

    end
  end
end