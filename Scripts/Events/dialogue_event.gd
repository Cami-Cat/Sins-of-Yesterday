extends Event
class_name Dialogue_Event

@export var dialogue : String = ""
@export var dialogueName : String = ""

func _on_execute() -> void:
	Constants.player.attacking = true
	Constants.UI._write_to_screen(dialogue, dialogueName)
	Constants.player.inDialogue = true
	self.get_parent().remove_child(self)
	Event_Manager.executed.add_child(self)
	emit_signal.call_deferred("executed")
