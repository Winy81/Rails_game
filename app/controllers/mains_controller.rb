class MainsController < ApplicationController
  def index
    @message = "Hello from Main"
    @characters = Character.all
  end

  def show

  end
end
