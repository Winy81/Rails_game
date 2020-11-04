module Services
  module SearchEngine
    module Character
      class CharacterSearch < Search

        def initialize(data)
          @data = data
        end

        def return_data
          character_fetch_by_id(@data)
        end
      end
    end
  end
end