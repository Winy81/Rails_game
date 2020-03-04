class MainsController < ApplicationController

  before_action :set_character_details, only: [:show]

  def index
    @message = "Hello from mains_controller#index"
    @characters = Character.all
  end

  def show
    @message = "Hello from mains_controller#index"
    @user = User.find(id=@character.user_id)
    @number_of_characters = Character.where(user_id:@user.id)
  end

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
