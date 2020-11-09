module Services
  module SearchEngine
    module Account
      class AccountSearch < Search

        def initialize(data)
          @data = data
        end

        def return_data
          if @data.match(UserRelatedFilters::ONLY_NUMBER) != nil
            user = user_fetch_by_id(@data)
          elsif @data.match(::UserRelatedFiltersVALID_EMAIL) != nil
            user = user_fetch_by_email(@data)
          elsif UserRelatedFilters::ROLES.include?(@data)
            user = user_fetch_by_role(@data)
          elsif UserRelatedFilters::ACTIVE_STATUS.include?(@data)
            user = user_fetch_by_activity(@data)
          elsif
            user =user_fetch_by_name(@data)
          end
          account_search_marker(user)
        end


        private

        def account_search_marker(user)
          user.map {|c| c.attributes.merge({'search_type' => 'account'}) }
        end

      end
    end
  end
end