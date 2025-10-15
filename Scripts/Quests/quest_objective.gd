extends Node
class_name QuestObjective

@warning_ignore("unused_signal")
signal completed(objective)
@warning_ignore("unused_signal")
signal updated(objective)

var isCompleted : bool = false

func finish(objective) -> void:
	isCompleted = true
	emit_signal("completed", objective)
	var parent = objective.get_parent()
	parent.remove_child(objective)
