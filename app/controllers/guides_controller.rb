class GuidesController < ApplicationController

  before_action :authenticate_user!

  def fed_state
    @message = "Hello from GuidesController#fed_state"
  end

  def activity_require_level
    @message = "Hello from GuidesController#activity_require_level"
    render 'activity_require'
  end

  def happiness
    @message = "Hello from GuidesController#happiness"
  end

end
