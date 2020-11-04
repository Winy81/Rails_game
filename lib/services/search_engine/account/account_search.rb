module Services
  module SearchEngine
    module Account
      class AccountSearch < Search

        def initialize(data)
          @data = data
        end

        def return_data
          if @data.match(ONLY_NUMBER) != nil
            user = user_fetch_by_id(@data)
          elsif @data.match(VALID_EMAIL) != nil
            user = user_fetch_by_email(@data)
          elsif ROLES.include?(@data)
            user = user_fetch_by_role(@data)
          elsif @data == ACTIVE || @data == INACTIVE
            user = user_fetch_by_activity(@data)
          elsif
            user =user_fetch_by_name(@data)
          end
          account_search_marker(user)
        end

      end
    end
  end
end