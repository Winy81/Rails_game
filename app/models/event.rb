class Event < ActiveRecord::Base

  validates_presence_of :event_id, :event_name, :description

end
