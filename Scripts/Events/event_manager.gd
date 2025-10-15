extends Node
class_name EventManager

@onready var executed = $Executed

func _ready() -> void:
	print("EVENT >> Initializing Event Manager...")
	print("EVENT >> Listening for Events...")
	
func _is_event_executed(event) -> bool:
	var state : bool = false
	for i in executed.get_children():
		if i.eventID == event.eventID:
			state = true
	return state

func _find_executed_event(eventID) -> Event:
	var found : Event
	for i in executed.get_children():
		if i .eventID == eventID:
			found = i
	return found

func _save() -> void:
	pass
