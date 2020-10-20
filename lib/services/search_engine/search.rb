module Services
  module SearchEngine
    class Search

      def initialize(data)
        @data = data
      end

      def data_response
        if @data.match(/\A\d+\Z/) != nil
          user_id_fetch
        elsif User::Role::ALL.include?(@data)
          fetch_by_role
        else
          User.where("name like ?", "%#{@data}%")
        end
      end

      private

      def user_id_fetch
        User.where(id:@data.to_i)
      end

      def fetch_by_role
        User.where(role:@data)
      end

    end
  end
end