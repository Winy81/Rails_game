module Services
  module SearchEngine
    module Character
      class CharacterSearch < Search

        def initialize(data)
          @data = data
        end

        def return_data
          if @data.match(ONLY_NUMBER) != nil
            characters = character_fetch_by_id_or_age(@data)
            character_search_marker(characters)
          end
        end

        private

        def character_search_marker(character)
          character.map {|c| c.attributes.merge({'search_type' => 'character'}) }
        end

      end
    end
  end
end