module Services
  module SearchEngine
    module Account
      class AccountSearch < Search

        def initialize(data)
          @data = data
        end

        def return_data
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

      end
    end
  end
end