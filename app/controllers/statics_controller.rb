class StaticsController < ApplicationController

  def about_us
    @message = "Hello from GuidesController#about_us"
  end

  def contact
    @message = "Hello from GuidesController#contact_us"
  end

  def game_description
    @message = "Hello from GuidesController#game_description"
  end

end
