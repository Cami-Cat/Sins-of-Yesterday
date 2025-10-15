extends Event
class_name Kick_Back_Event

@onready var player = Constants.player

func _define_self(instance) -> void:
	player = instance

func _on_execute() -> void:
	var tween = create_tween()
	var newDir
	match Constants.looking:
		Constants.dir.up:
			newDir = Vector2(0, Constants.TILE_SIZE)
			Constants.looking = Constants.dir.down
		Constants.dir.down:
			newDir = Vector2(0, -Constants.TILE_SIZE)
			Constants.looking = Constants.dir.up
		Constants.dir.left:
			newDir = Vector2(Constants.TILE_SIZE, 0)
			Constants.looking = Constants.dir.right
		Constants.dir.right:
			newDir = Vector2(-Constants.TILE_SIZE, 0)
			Constants.looking = Constants.dir.left
	
	player.movement.cast.target_position = newDir
	player.movement.cast.force_raycast_update()
	player._check_direction()
	tween.tween_property(player, "position", (player.global_position + newDir), 0.1).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	tween.kill()
	self.get_parent().remove_child(self)
	Event_Manager.executed.add_child(self)
	emit_signal.call_deferred("executed")
	print("EVENT >> Kick Back has been executed on player.")
