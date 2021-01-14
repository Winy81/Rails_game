class Event < ActiveRecord::Base

  validate :exist_event
  validates_presence_of :event_id, :event_name, :description

  private

  def exist_event
    accepted_event_ids = ids_of_special_events + ids_of_character_events
    unless accepted_event_ids.include?(event_id)
      errors.add(:event_id, " : #{event_id} is a NOT valid event_id")
    end
  end

  def ids_of_special_events
    event_module = Jobs::CharacterSpecialEventRunner::SpecialEventList
    events = event_module.constants
    list_of_event_ids = []
    events.each do |event|
      list_of_event_ids << event_module.const_get("#{event}::ID")
    end
    list_of_event_ids
  end

  def ids_of_character_events
    event_module = Jobs::CharacterEventRunner::RandomEventList
    events = event_module.constants
    list_of_event_ids = []
    events.each do |event|
      list_of_event_ids << event_module.const_get("#{event}::ID")
    end
    list_of_event_ids
  end

end
