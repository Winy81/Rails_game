class CharactersController < ApplicationController

  before_action :set_character_details, only: [:show, :character_info, :destroy, :feeding, :activity, :update]
  before_action :authenticate_user!

  def index
    @message = "Hello from CharactersController#index"
    @characters = Character.all.age_order_alive_filter
  end

  def all_of_my_character
    @message = "Hello from CharactersController#all_of_my_character"
    @characters = Character.where(user_id: current_user.id).order(:id => :desc)
  end

  def show
    @message = "Hello from CharactersController#show"
  end

  def feeding
    @message = "Hello from CharactersController#feeding"
  end

  def activity
    @message = "Hello from CharactersController#activity"
  end

  def update
    route = request_path_recognise_helper(params[:extra])
    if route == "feeding"
      update_fed_state(@character)
    elsif route == "activity"
      update_activity_state(@character)
    end
  end

  def new
    Character.new
  end

  def create
    @character = Character.new(character_params)
    if @character.save
      redirect_to character_path(@character), notice: "The character with id: #{current_character.id} has became alive!!!"
    else
      redirect_to new_character_path, notice: "The character has not been created"
    end
  end

  def destroy
    current_character = @character
    @character.delete
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

  def update_fed_state(character)
    if character.update_attributes(:fed_state => params[:fed_state])
      redirect_to character_path(character), notice: "Fed_points added"
    else
      redirect_to character_path(character), notice: "Did not like it"
    end
  end

  def update_activity_state(character)
    if character.update_attributes(:activity_require_level => params[:activity_require_level])
      redirect_to character_path(character), notice: "Activity points has burned down"
    else
      redirect_to character_path(character), notice: "Did not like it"
    end
  end

end
