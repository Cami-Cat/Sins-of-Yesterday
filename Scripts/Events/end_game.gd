extends Event
class_name End_Game_Event

@export var delay : float = 0.0

func _on_execute() -> void:
	Constants.player.canMove = false
	Constants.player.attacking = false
	await get_tree().create_timer(delay).timeout
	Constants.UI._hide_from_screen()
	Constants.UI.blackBar.visible = true
	Constants.UI.blackBar.modulate.a = 0.0
	
	Constants.UI.credits.visible = true

	var tween = create_tween()
	tween.tween_property(Constants.UI.blackBar, "modulate:a", 1.0, 2.0).set_trans(tween.TRANS_LINEAR)
	var creditsTween = create_tween()
	creditsTween.tween_property(Constants.UI.credits, "position:y", -450, 12.0).set_trans(tween.TRANS_LINEAR)
	
	self.get_parent().remove_child(self)
	Event_Manager.executed.add_child(self)
	emit_signal.call_deferred("executed")
	await creditsTween.finished
	get_tree().quit()
