class GuidesController < ApplicationController

  def fed_state
    @message = "Hello from GuidesController#fed_state"
  end

  def activity_require_level
    render 'activity_require'
  end

  def happiness
    @message = "Hello from GuidesController#happiness"
  end

  def age

  end

  def hibernated
    @message = "Hello from GuidesController#hibernated"
  end

  def status
    @message = "Hello from GuidesController#status"
  end



end
