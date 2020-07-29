class CharactersController < ApplicationController

  before_action :set_character_details_with_owner_filter, only: [:show,
                                                                 :destroy,
                                                                 :update,
                                                                 :feeding,
                                                                 :feeding_process,
                                                                 :feeding_deny,
                                                                 :activity,
                                                                 :activity_deny,
                                                                 :activity_process,
                                                                 :playing,
                                                                 :playing_deny,
                                                                 :playing_process]

  before_action :authenticate_user!
  before_action :alive_check, only: [:show,
                                     :feeding,
                                     :feeding_deny,
                                     :feeding_process,
                                     :activity,
                                     :activity_deny,
                                     :activity_process,
                                     :playing,
                                     :playing_deny,
                                     :playing_process,
                                     :update]


  rescue_from ActiveRecord::RecordNotFound, with: :no_character_exist_rescue

  def index
    @characters = Character.all.order(:age => :desc).limit(10)
    @my_character = @characters.where(user_id: current_user.id, status:'alive').first
  end

  def all_of_my_character
    @characters = Character.where(user_id: current_user.id).order(:id => :desc)
  end

  def characters_history
    if params[:id].to_i == current_user.id
      redirect_to all_of_my_character_path
    else
      @owner_of_character = User.find_by(id:params[:id])
      @owners_characters = Character.where(user_id:@owner_of_character.id).order(:status => :asc, :id => :desc)
    end
  end

  def show

  end

  def feeding

  end

  def feeding_deny
    redirection_to_character_path(@character,'alert', "Opps, your character couldn't finish the meal")
  end

  def feeding_process
    @current_amount = params[:amount].to_i
    @spendable_amount = -1*(@current_user.wallet.amount - @current_amount)
    @current_fed_state = params[:fed_state]
    @current_activity_state = params[:activity_require_level]
    @current_happiness_state = params[:happiness]
    @costs = wallet_view - @current_amount
    if not_enough_available_activity_points?
      redirection_to_character_path(@character,'warning', 'Your are too tired to move')
    else
      if paying_service_budget_check?(@spendable_amount) == true
        @sent_potion_of_food = -1*(@character.fed_state.to_i - @current_fed_state.to_i)
        @sent_points_of_activity = -1*(@character.activity_require_level.to_i - @current_activity_state.to_i)
        @sent_happiness_points = -1*(@character.happiness.to_i - @current_happiness_state.to_i)
      else
        redirection_to_character_path(@character,'warning', 'Your have not enough Gold for this action')
      end
    end
  end

  def activity

  end

  def activity_deny
    redirection_to_character_path(@character,'alert', "Opps, your character couldn't finish the training")
  end

  def activity_process
    @current_amount = params[:amount]
    @current_fed_state = params[:fed_state]
    @current_activity_state = params[:activity_require_level]
    @current_happiness_state = params[:happiness]
    @earn = -1*(wallet_view - @current_amount.to_i)
    if not_enough_available_activity_points?
      redirection_to_character_path(@character,'warning', 'Your are too tired to move')
    elsif not_enough_available_feeding_points?
      redirection_to_character_path(@character,'warning', 'Your are too hungry to move')
    else
      @sent_potion_of_food = -1*(@character.fed_state.to_i - @current_fed_state.to_i)
      @sent_points_of_activity = -1*(@character.activity_require_level.to_i - @current_activity_state.to_i)
      @sent_happiness_points = -1*(@character.happiness.to_i - @current_happiness_state.to_i)
    end
  end

  def playing

  end

  def playing_deny
    redirection_to_character_path(@character,'alert', 'Opps, your character has not become Happy')
  end

  def playing_process
    @current_amount = params[:amount].to_i
    @spendable_amount = -1*(@current_user.wallet.amount - @current_amount)
    @current_fed_state = params[:fed_state]
    @current_activity_state = params[:activity_require_level]
    @current_happiness_state = params[:happiness]
    @costs = wallet_view - @current_amount
    if not_enough_available_activity_points?
      redirection_to_character_path(@character,'warning', 'Your are too tired to move')
    elsif not_enough_available_feeding_points?
      redirection_to_character_path(@character,'warning', 'Your are too hungry to move')
    else
      if paying_service_budget_check?(@spendable_amount) == true
        @sent_potion_of_food = -1*(@character.fed_state.to_i - @current_fed_state.to_i)
        @sent_points_of_activity = -1*(@character.activity_require_level.to_i - @current_activity_state.to_i)
        @sent_happiness_points = -1*(@character.happiness.to_i - @current_happiness_state.to_i)
      else
        redirection_to_character_path(@character,'warning', 'Your have not enough Gold for this action')
      end
    end
  end

  def update
    if path_recogniser == 'feeding'
      update_fed_state(@character)
    elsif path_recogniser == 'activity'
      update_from_activity_state(@character)
    elsif path_recogniser == 'playing'
      update_playing_state(@character)
    end
  end

  def new
    if alive_check_for_create_character
      redirection_to_characters_path('alert','You have a character Alive')
    else
      Character.new
    end
  end

  def create
    if alive_check_for_create_character
      redirection_to_characters_path('alert','You have a character Alive')
    else
      @character = Character.new(character_params)
      update_user_has_character_field(current_user)
      if @character.save
        WalletServices::BasicWalletCreator.new(current_user).setup_starter_amount
        redirection_to_character_path(@character,'notice', 'Tha character has born. You gave name: ', @character.name)
      else
        flash.now[:alert] = 'The character has not been created'
        render :new
      end
    end
  end

  def destroy
    current_character = @character
    if @character.delete
      redirection_to_characters_path('warning','Character has been deleted with id:', current_character.id)
    else
      redirection_to_characters_path('alert','Was not successful to delete Character with id:', current_character.id)
    end
  end

  def character_info
    @character = Character.find(params[:id])
    @user = User.find_by(id:@character.user_id)
  end

  private

  def set_character_details_with_owner_filter
    @character = Character.find(params[:id])
    if @character.user_id != current_user.id
      redirection_to_characters_path('alert','That Character is not Yours!')
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
    if character.update_attributes(:fed_state => fed_limit.fed_level_max_setter,
                                   :activity_require_level => activity_limit.activity_level_min_setter,
                                   :happiness => happiness_limit.happiness_level_max_setter)

      if character.fed_state == 100
        redirection_to_character_path(character,'warning', 'Your character is full')
      else
        redirection_to_character_path(character,'notice', 'Fed point added')
      end
      paying_service_proceed
    else
      redirection_to_character_path(character,'alert', 'Did not like it')
    end
  end

  def update_from_activity_state(character)
    if character.update_attributes(:fed_state => fed_limit.fed_level_max_setter,
                                   :activity_require_level => activity_limit.activity_level_min_setter,
                                   :happiness => happiness_limit.happiness_level_max_setter)
        paying_service_proceed
        redirection_to_character_path(character,'notice', 'You have beaten the challenge and reached Gold')
    else
      redirection_to_character_path(character,'alert', 'Did not move')
    end
  end

  def update_playing_state(character)
    if character.update_attributes(:fed_state => fed_limit.fed_level_max_setter,
                                   :activity_require_level => activity_limit.activity_level_min_setter,
                                   :happiness => happiness_limit.happiness_level_max_setter)
      if character.happiness == 100
        redirection_to_character_path(character,'warning', 'Your Character do not want to play more')
      else
        redirection_to_character_path(character,'notice', 'Happiness point added')
      end
      paying_service_proceed
    else
      redirection_to_character_path(character,'alert', 'Did not move')
    end
  end

  def paying_service_budget_check?(amount)
    WalletServices::WalletActionManager.new(current_user, amount).budget_check?
  end

  def paying_service_proceed
    WalletServices::WalletActionManager.new(current_user, params[:amount].to_i).action_amount_calculator
  end

  def fed_limit
    CharactersServices::DataFieldLimitSetter.new(params[:fed_state].to_i)
  end

  def activity_limit
    CharactersServices::DataFieldLimitSetter.new(params[:activity_require_level].to_i)
  end

  def happiness_limit
    CharactersServices::DataFieldLimitSetter.new(params[:happiness].to_i)
  end

  def path_recogniser
    CharactersServices::RequestPathRecogniser.new(params[:extra]).request_path_recognise_helper
  end

  def alive_check
    @character.status == 'alive' ? true : redirection_to_characters_path('warning','This Character is Dead already!')
  end

  def alive_check_for_create_character
    Character.where(user_id:current_user.id, status:'alive').count > 0
  end

  def redirection_to_characters_path(type, message, extra='')
    output_type = type.to_sym
    redirect_to characters_path, {output_type => "#{message} #{extra}"}
  end

  def redirection_to_character_path(current_character,type, message, extra='')
    output_type = type.to_sym
    redirect_to character_path(current_character), {output_type => "#{message} #{extra}"}
  end

  def update_user_has_character_field(user)
    user.update_attributes(has_character:true)
  end

  def no_character_exist_rescue
    redirection_to_characters_path('alert','That Character is not exist!')
  end

  def not_enough_available_activity_points?
    params[:activity_require_level].to_i < 0
  end

  def not_enough_available_feeding_points?
    params[:fed_state].to_i < 0
  end

end


