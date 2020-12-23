class Event < ActiveRecord::Base

  validates :event_id, presence: true
  validates :event_name, presence: true
  validates :description, presence: true

end
