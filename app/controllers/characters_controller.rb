class CharactersController < ApplicationController

  before_action :set_character_details_with_owner_filter, only: [:show,
                                                                 :destroy,
                                                                 :feeding,
                                                                 :activity,
                                                                 :update,
                                                                 :feeding_process,
                                                                 :activity_process]
  before_action :authenticate_user!
  before_action :alive_check, only: [:show, :feeding, :activity, :feeding_process, :activity_process, :update ]

  def index
    @message = "Hello from CharactersController#index"
    @characters = Character.all.age_order_alive_filter
    @my_character = @characters.where(user_id: current_user.id, status:'alive').first
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

  def feeding_process
    @message = "Hello from CharactersController#feeding_process"
    @sent_potion_of_food = -1*(@character.fed_state.to_i - params[:fed_state].to_i)
    @current_fed_state = params[:fed_state]
  end

  def activity
    @message = "Hello from CharactersController#activity"
  end

  def activity_process
    @message = "Hello from CharactersController#activity_process"
    @sent_points_of_activity = (@character.activity_require_level.to_i - params[:activity_require_level].to_i)
    @current_activity_state = params[:activity_require_level]
  end

  def update
    if path_recogniser == "feeding"
      update_fed_state(@character)
    elsif path_recogniser == "activity"
      update_activity_state(@character)
    end
  end

  def new
    @message = "Hello from CharactersController#new"
    if Character.where(user_id:current_user.id).count > 0
      redirection_to_characters_path("alert","You have a character Alive")
    else
      Character.new
    end
  end

  def create
    if Character.where(user_id:current_user.id).count > 0
      redirection_to_characters_path("alert","You have a character Alive")
    else
      @character = Character.new(character_params)
      if @character.save
        redirection_to_character_path(@character,"notice", "Tha character has born. You gave name: ", @character.name)
      else
        flash.now[:alert] = "The character has not been created"
        render :new
      end
    end
  end

  def destroy
    current_character = @character
    if @character.delete
      redirection_to_characters_path("warning","Character has been deleted with id:", current_character.id)
    else
      redirection_to_characters_path("alert","Was not successful to delete Character with id:", current_character.id)
    end
  end

  def character_info
    @message = "Hello from CharactersController#character_info"
    @character = Character.find(params[:id])
    @user = User.find_by(id:@character.user_id)
  end

  def owner_info
    @message = "Hello from CharactersController#owner_info"
    @user = User.find(params[:id])
  end

  private

  def set_character_details_with_owner_filter
    @character = Character.find(params[:id])
    if @character.user_id != current_user.id
      redirection_to_characters_path("alert","That Character is not Yours!")
    end
  end

  def character_params
    params.require(:character).permit(:id,
                                      :user_id,
                                      :name,
                                      :status,
                                      :age,
                                      :happiness,
                                      :fed_state,
                                      :activity_require_level)
  end

  def update_fed_state(character)
    if character.update_attributes(:fed_state => fed_limit.fed_level_max_setter)
      if character.fed_state == 100
        redirection_to_character_path(character,"warning", "Your are full")
      else
        redirection_to_character_path(character,"notice", "Fed point added")
      end
    else
      redirection_to_character_path(character,"alert", "Did not like it")
    end
  end

  def update_activity_state(character)
    if character.update_attributes(:activity_require_level => params[:activity_require_level])
      redirection_to_character_path(character,"notice", "Activity points has burned down")
    else
      redirection_to_character_path(character,"alert", "Did not move")
    end
  end

  def fed_limit
    CharactersServices::DataFieldLimitSetter.new(params[:fed_state].to_i)
  end

  def path_recogniser
    CharactersServices::RequestPathRecogniser.new(params[:extra]).request_path_recognise_helper
  end

  def alive_check
    @character.status == "alive" ? true : redirection_to_characters_path("warning","This Character is dead")
  end

  def redirection_to_characters_path(type, message, extra="")
    output_type = type.to_sym
    redirect_to characters_path, {output_type => "#{message} #{extra}"}
  end

  def redirection_to_character_path(current_character,type, message, extra="")
    output_type = type.to_sym
    redirect_to character_path(current_character), {output_type => "#{message} #{extra}"}
  end

end


