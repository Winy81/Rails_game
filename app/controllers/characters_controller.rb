class CharactersController < ApplicationController

  before_action :set_character_details, only: [:show]

  def show

  end

  def new

  end

  def create

  end

  private

  def set_character_details
    @character= Character.find(params[:id])
  end

  def character_params
    params.require(:character).permit(:name,
                                      :status,
                                      :age,
                                      :happiness,
                                      :fed_state,
                                      :activity_require_level)
  end
end
