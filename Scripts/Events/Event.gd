extends Node
class_name Event

signal events_complete
signal executed

@onready var events = self

@export var eventID : int
@export var eventStart : int
@export var eventRequirements : Array[int] = []

var hasStarted : bool = false

func _ready() -> void:
	for event in events.get_children():
		event.connect("executed", _on_event_completion)
		print("EVENT >> Pairing event: [" + event.name + "] to: [" + self.name + "]")

func _get_events() -> Array:
	return events.get_children()

func _on_event_completion() -> void:
	if self.get_children().size() == 0:
		print("EVENT >> All events in: [" + self.get_parent().name + "] have been completed.")
		emit_signal("events_complete")
		queue_free()
