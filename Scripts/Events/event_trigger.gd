extends Area2D
class_name Event_Trigger

signal executed

@onready var events = $Events
@export var questRequirements : Array[int]
@export var killOnComplete : bool = false

func _execute_events() -> void:
	print("EVENT >> Player has walked into event area.")
	if _are_requirements_met().size() == questRequirements.size():
		queue_free()
		return
	for event in events.get_children():
		print("EVENT >> executing: [" + event.name + "]")
		event.connect("executed", _is_completed)
		event._on_execute()
	if killOnComplete == true:
		pass
		# await get_tree().create_timer(0.5).timeout
		# queue_free()

func _are_requirements_met() -> Array:
	var reqArr : Array
	for i in Quest_Manager.completed.get_children():
		if questRequirements.has(i.questID) == true:
			reqArr.append(i.questID)
	return reqArr

func _is_completed() -> void:
	var arr = get_children()
	if arr.size() == 0:
		print("EVENT >> Completed all events, culling")
		queue_free()
