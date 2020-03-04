class MainsController < ApplicationController
  def index
    @message = "Hello from mains_controller#index"
    @characters = Character.all
  end

  def show
    @message = "Hello from mains_controller#index"
  end
end
