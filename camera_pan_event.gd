extends Event
class_name Camera_Pan_Event

@export var panSpeed : float = 1
@export var panTo : Node
@export var panBackDelay : float = 0.0
var originalPosition : Vector2


func _on_execute() -> void:
	originalPosition = Constants.player.global_position
	
	_pan_to(panTo.global_position, panSpeed)
	await get_tree().create_timer(panBackDelay).timeout
	_pan_to(originalPosition, panSpeed)
	
	#Constants.player.attacking = false
	#self.get_parent().remove_child(self)
	#Event_Manager.executed.add_child(self)
	#emit_signal.call_deferred("executed")

func _pan_to(destination : Vector2, delay : float) -> void:
	var tween = create_tween()
	tween.tween_property(Constants.player.camera, "global_position", destination, delay).set_trans(tween.TRANS_LINEAR)
	
