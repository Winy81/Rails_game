class AdminsController < ApplicationController

  before_action :is_user_admin?
  before_action :admin_path_recogniser?

  UPDATE_USER_ATTRS = [:id, :name, :email, :role]
  UPDATE_BUDGET_ATTR = [:budget]
  UPDATE_CHARACTER_ATTR = [:id,
                           :name,
                           :status,
                           :age,
                           :happiness,
                           :fed_state,
                           :activity_require_level,
                           :created_at,
                           :user_id,
                           :hibernated,
                           :manualy_hibernated,
                           :died_on]

  def index

  end

  def edit_user
    @user = User.find_by(id:params[:id])
  end

  def edit_character
    @character = Character.find_by(id:params[:id])
  end

  def user_update_by_admin
    @user = User.find_by(id:params[:id])
    if @user.update_attributes(update_user_params) && @user.set_budget(update_wallet_params[:budget])
      redirection_to_admin_index_path('notice', 'User details has updated.')
    else
      redirection_to_admin_index_path('alert','User details has NOT been updated.')
    end
  end

  def character_update_by_admin
    @character = Character.find_by(id:params[:id])
    if @character.update_attributes(update_character_params)
      redirection_to_admin_index_path('notice', 'Character details has updated.')
    else
      redirection_to_admin_index_path('alert','Character details has NOT been updated.')
    end
  end

  def account_management
    @users = User.all.user_in_asc_id_order
  end

  def character_management
    @characters = Character.all.character_in_asc_id_order
  end

  def search
    @response= Services::SearchEngine::Search.new(params[:search_params], params[:commit]).response
    if @response.first["search_type"] == "account"
      @users = @response
    elsif @response.first["search_type"] == "character"
      @characters = @response
    else
      return false
    end
  end

  private

  def is_user_admin?
    current_user.role == 'admin' ? true : redirection_to_characters_path('alert', 'You have no admin privileges')
  end

  def update_user_params
    params.require(:user).permit(UPDATE_USER_ATTRS)
  end

  def update_wallet_params
    binding.pry
    params.require(:user).permit(UPDATE_BUDGET_ATTR)
  end

  def update_character_params
    params.require(:character).permit(UPDATE_CHARACTER_ATTR)
  end

  def admin_path_recogniser?
    @admin_path = params['controller'] == 'admins' ? true : false
  end

end
