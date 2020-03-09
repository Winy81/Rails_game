class CharactersController < ApplicationController

  before_action :set_character_details, only: [:show, :character_info, :destroy]
  before_action :authenticate_user!

  def index
    @message = "Hello from character_controller#index"
    @characters = Character.all.age_order_alive_filter
  end

  def all_of_my_character
    @message = "Hello from character_controller#all_of_my_character"
    @characters = Character.where(user_id: current_user.id).order(:id => :desc)
  end

  def show

  end

  def new

  end

  def create

  end

  def destroy
    current_character = @character.delete
    redirect_to characters_path, notice: "The character with id: #{current_character.id} has been deleted"
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
