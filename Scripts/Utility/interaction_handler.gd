extends Node
class_name InteractionHandler

@onready var movement : GridMovement = self.get_parent()

func _on_interact() -> void:
	var cast = movement.cast
	cast.force_raycast_update()
	var target = cast.get_collider()
	if target == null:
		return
	if target.is_in_group("interactive"):
		target._interact()
