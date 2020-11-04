module Services
  module SearchEngine
    class Search

      include ActiveModel::AttributeMethods

      VALID_EMAIL= /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      ONLY_NUMBER = /\A\d+\Z/
      ROLES = User::Role::ALL
      ACTIVE = 'active'
      INACTIVE = 'inactive'

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
        activity_status == 'active' ? User.where(has_character:true) : User.where(has_character:true)
      end

      def user_fetch_by_name(name)
        User.where("name like ?", "%#{name}%")
      end

      def character_fetch_by_id(id)
        ::Character.where(id:id.to_i)
      end

      def account_search_marker(user)
        user.map {|c| c.attributes.merge({'search_type' => 'account'}) }
      end

      def character_search_marker
        attributes.merge({'search_type' => 'character'})
      end

      #def fetch_by_user_since(data) if Date.parse("2020-10-15").class == Date
      #  User.where(created_at:Date.parse(data))
      #end

      def json_converter
        a=@results.to_json
        b=JSON.parse(a)
        b << ({'search_type' => 'account'})
      end

    end
  end
end