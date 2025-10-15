extends QuestObjective
class_name QuestInteractObjective

@warning_ignore("unused_signal")
signal interaction(pawn)

@export var interact_with : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("QUEST >> Interact Objective: [" + self.name + "] of: [" + self.get_parent().get_parent().name + "] ready.")
	for interactive_pawn in get_tree().get_nodes_in_group("interactive"):
		interactive_pawn.connect("interaction", _on_interaction_completed)

func _on_interaction_completed(pawn) -> void:
	return
	if pawn.name == interact_with.name and not isCompleted:
		print("QUEST >> Objective Completed.")
		isCompleted = true
		finish(self)
