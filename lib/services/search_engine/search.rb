module Services
  module SearchEngine
    class Search

      VALID_EMAIL= /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      ONLY_NUMBER = /\A\d+\Z/
      ROLES = User::Role::ALL
      ACTIVE = 'active'
      INACTIVE = 'inactive'

      def initialize(data)
        @data = data
      end

      def data_response
        if @data.match(ONLY_NUMBER) != nil
          fetch_by_id(@data)
        elsif @data.match(VALID_EMAIL) != nil
          fetch_by_email(@data)
        elsif ROLES.include?(@data)
          fetch_by_role(@data)
        elsif @data == ACTIVE || @data == INACTIVE
          fetch_by_activity(@data)
        elsif
          fetch_by_name(@data)
        end
      end

      private

      def fetch_by_id(id)
        User.where(id:id.to_i)
      end

      def fetch_by_email(email)
        User.where(email:email)
      end

      def fetch_by_role(role)
        User.where(role:role)
      end

      def fetch_by_activity(activity_status)
        activity_status == 'active' ? User.where(has_character:true) : User.where(has_character:true)
      end

      def fetch_by_name(name)
        User.where("name like ?", "%#{name}%")
      end

      #def fetch_by_user_since(data) if Date.parse("2020-10-15").class == Date
      #  User.where(created_at:Date.parse(data))
      #end

    end
  end
end