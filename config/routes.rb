Rails.application.routes.draw do

  devise_for :users
  resources :mains, only: [:index, :show]
  resources :characters, only: [:index, :new, :show, :create, :destroy, :update]

  get 'leaderboard', to: 'mains#leaderboard', as: :leaderboard

  get 'character_info/:id', to: 'characters#character_info', as: :character_info
  get 'all_of_my_character', to: 'characters#all_of_my_character', as: :all_of_my_character
  get 'character/:id/feeding', to: 'characters#feeding', as: :character_feeding
  get 'character/:id/activity', to: 'characters#activity', as: :character_activity

  post 'character/:id/feeding_process', to: 'characters#feeding_process', as: :feeding_process
  get 'character/:id/feeding_process', to: 'characters#feeding_deny'
  post 'character/:id/activity_process', to: 'characters#activity_process', as: :activity_process
  get 'character/:id/activity_process', to: 'characters#activity_deny'

  scope '/user' do
    get ':id/characters_history', to: 'characters#characters_history', as: :characters_history
  end

  scope '/info' do
    get 'guides/fed_state', to: 'guides#fed_state', as: :fed_state
    get 'guides/activity_require', to: 'guides#activity_require_level', as: :activity_require
    get 'guides/happiness', to: 'guides#happiness', as: :happiness
    get 'guides/age', to: 'guides#age', as: :age
    get 'guides/hibernated', to: 'guides#hibernated', as: :hibernated
    get 'guides/status', to: 'guides#status', as: :status

    get 'statics/about_us', to: 'statics#about_us', as: :about_us
    get 'statics/contact', to: 'statics#contact', as: :contact
    get 'statics/game_description', to: 'statics#game_description', as: :game_description
  end

  root to: 'mains#index'

end
