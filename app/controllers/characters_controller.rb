class CharactersController < ApplicationController

  before_action :set_character_details, only: [:show, :character_info]
  before_action :authenticate_user!

  def index
    @message = "Hello from charatcer_controller#index"
    @characters = Character.all.age_order_alive_filter
  end

  def show

  end

  def new

  end

  def create

  end

  def character_info

  end

  private

  def set_character_details
    @character = Character.find(params[:id])
  end

  def character_params
    params.require(:character).permit(:id,
                                      :name,
                                      :status,
                                      :age,
                                      :happiness,
                                      :fed_state,
                                      :activity_require_level)
  end
end
