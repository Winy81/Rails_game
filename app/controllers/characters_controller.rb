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
    @characters = Character.limited_desc_ordered_characters
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
      @owners_characters = Character.where(user_id:@owner_of_character.id).characters_history_order_logic
    end
  end

  def show

  end

  def feeding

  end

  def feeding_deny
    redirection_to_character_path(@character,'alert', I18n.t('characters.action_alerts.could_not_finish_meal'))
  end

  def feeding_process
    @current_amount = params[:amount].to_i
    @spendable_amount = -1*(@current_user.wallet.amount - @current_amount)
    @current_fed_state = params[:fed_state]
    @current_activity_state = params[:activity_require_level]
    @current_happiness_state = params[:happiness]
    @costs = wallet_view - @current_amount
    if not_enough_available_activity_points?
      redirection_to_character_path(@character,'warning', I18n.t('characters.action_warnings.you_can_not_move'))
    else
      if paying_service_budget_check?(@spendable_amount) == true
        @sent_potion_of_food = -1*(@character.fed_state.to_i - @current_fed_state.to_i)
        @sent_points_of_activity = -1*(@character.activity_require_level.to_i - @current_activity_state.to_i)
        @sent_happiness_points = -1*(@character.happiness.to_i - @current_happiness_state.to_i)
      else
        redirection_to_character_path(@character,'warning', I18n.t('characters.action_warnings.low_on_gold'))
      end
    end
  end

  def activity

  end

  def activity_deny
    redirection_to_character_path(@character,'alert', I18n.t('characters.action_alerts.could_not_finish_training'))
  end

  def activity_process
    @current_amount = params[:amount]
    @current_fed_state = params[:fed_state]
    @current_activity_state = params[:activity_require_level]
    @current_happiness_state = params[:happiness]
    @earn = -1*(wallet_view - @current_amount.to_i)
    if not_enough_available_activity_points?
      redirection_to_character_path(@character,'warning', I18n.t('characters.action_warnings.you_can_not_move'))
    elsif not_enough_available_feeding_points?
      redirection_to_character_path(@character,'warning', I18n.t('characters.action_warnings.you_can_not_eat'))
    else
      @sent_potion_of_food = -1*(@character.fed_state.to_i - @current_fed_state.to_i)
      @sent_points_of_activity = -1*(@character.activity_require_level.to_i - @current_activity_state.to_i)
      @sent_happiness_points = -1*(@character.happiness.to_i - @current_happiness_state.to_i)
    end
  end

  def playing

  end

  def playing_deny
    redirection_to_character_path(@character,'alert', I18n.t('characters.action_alerts.could_not_finish_playing'))
  end

  def playing_process
    @current_amount = params[:amount].to_i
    @spendable_amount = -1*(@current_user.wallet.amount - @current_amount)
    @current_fed_state = params[:fed_state]
    @current_activity_state = params[:activity_require_level]
    @current_happiness_state = params[:happiness]
    @costs = wallet_view - @current_amount
    if not_enough_available_activity_points?
      redirection_to_character_path(@character,'warning', I18n.t('characters.action_warnings.you_can_not_move'))
    elsif not_enough_available_feeding_points?
      redirection_to_character_path(@character,'warning', I18n.t('characters.action_warnings.you_can_not_eat'))
    else
      if paying_service_budget_check?(@spendable_amount) == true
        @sent_potion_of_food = -1*(@character.fed_state.to_i - @current_fed_state.to_i)
        @sent_points_of_activity = -1*(@character.activity_require_level.to_i - @current_activity_state.to_i)
        @sent_happiness_points = -1*(@character.happiness.to_i - @current_happiness_state.to_i)
      else
        redirection_to_character_path(@character,'warning', I18n.t('characters.action_warnings.low_on_gold'))
      end
    end
  end

  def update
    if path_recogniser == 'feeding'
      update_fed_state(@character)
    elsif path_recogniser == 'activity'
      update_activity_state(@character)
    elsif path_recogniser == 'playing'
      update_playing_state(@character)
    end
  end

  def new
    if alive_check_for_create_character
      redirection_to_characters_path('alert', I18n.t('characters.action_alerts.you_have_character_alive'))
    else
      Character.new
    end
  end

  def create
    if alive_check_for_create_character
      redirection_to_characters_path('alert',I18n.t('characters.action_alerts.you_have_character_alive'))
    else
      @character = Character.new(character_params)
      update_user_has_character_field(current_user)
      if @character.save
        WalletServices::BasicWalletCreator.new(current_user).setup_starter_amount
        redirection_to_character_path(@character,'notice', I18n.t('characters.action_notices.character_has_born'), @character.name)
      else
        flash.now[:alert] = I18n.t('characters.action_alerts.something_went_wrong_on_character_creation')
        render :new
      end
    end
  end

  def destroy
    current_character = @character
    if @character.delete
      redirection_to_characters_path('warning', I18n.t('characters.action_warnings.character_has_been_destroyed'), current_character.id)
    else
      redirection_to_characters_path('alert', I18n.t('characters.action_alerts.something_went_wrong_on_character_destroying'), current_character.id)
    end
  end

  def character_info
    @character = Character.find(params[:id])
    @user = @character.user
  end

  private

  def set_character_details_with_owner_filter
    @character = Character.find(params[:id])
    if @character.user_id != current_user.id
      redirection_to_characters_path('alert', I18n.t('characters.action_alerts.that_character_is_not_yours'))
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
        redirection_to_character_path(character,'warning', I18n.t('characters.action_warnings.you_can_not_eat_more'))
      else
        redirection_to_character_path(character,'notice', I18n.t('characters.action_notices.feeding_action_has_been_proceed'))
      end
      paying_service_proceed
    else
      redirection_to_character_path(character,'alert', I18n.t('characters.action_alerts.un_success_feeding_process'))
    end
  end

  def update_activity_state(character)
    if character.update_attributes(:fed_state => fed_limit.fed_level_max_setter,
                                   :activity_require_level => activity_limit.activity_level_min_setter,
                                   :happiness => happiness_limit.happiness_level_max_setter)
        paying_service_proceed
        redirection_to_character_path(character,'notice', I18n.t('characters.action_notices.activity_action_has_been_proceed'))
    else
      redirection_to_character_path(character,'alert', I18n.t('characters.action_alerts.un_success_activity_process'))
    end
  end

  def update_playing_state(character)
    if character.update_attributes(:fed_state => fed_limit.fed_level_max_setter,
                                   :activity_require_level => activity_limit.activity_level_min_setter,
                                   :happiness => happiness_limit.happiness_level_max_setter)
      if character.happiness == 100
        redirection_to_character_path(character,'warning', I18n.t('characters.action_warnings.you_can_not_play_more'))
      else
        redirection_to_character_path(character,'notice', I18n.t('characters.action_notices.playing_action_has_been_proceed'))
      end
      paying_service_proceed
    else
      redirection_to_character_path(character,'alert', I18n.t('characters.action_alerts.un_success_activity_process'))
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
    @character.status == 'alive' ? true : redirection_to_characters_path('warning', I18n.t('characters.action_warnings.character_is_dead'))
  end

  def alive_check_for_create_character
    Character.where(user_id:current_user.id, status:'alive').count > 0
  end

  def update_user_has_character_field(user)
    user.update_attributes(has_character:true)
  end

  def no_character_exist_rescue
    redirection_to_characters_path('alert', I18n.t('characters.action_alerts.not_exist_character'))
  end

  def not_enough_available_activity_points?
    params[:activity_require_level].to_i < 0
  end

  def not_enough_available_feeding_points?
    params[:fed_state].to_i < 0
  end

end


