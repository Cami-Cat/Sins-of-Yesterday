extends Event
class_name SpawnItemEvent

@export var itemToSpawn : PackedScene
@export var actorToSpawnOn : Node

func _ready() -> void:

	if Event_Manager._find_executed_event(eventID) != null:
		queue_free()

	if self.get_parent() != null:
		print("EVENT >> Succesfully connected [" + self.name + "] to: [" + self.get_parent().get_parent().name + "]")

func _on_execute() -> void:
	print("EVENT >> Executing event: [" + self.name + "]")
	_spawn_item_on_player()
	self.get_parent().remove_child(self)
	Event_Manager.executed.add_child(self)
	emit_signal.call_deferred("executed")

func _spawn_item_on_player() -> void:
	var player = Constants.player
	var item = itemToSpawn.instantiate()
	actorToSpawnOn.add_child(item)
	player._get_item(itemToSpawn)
	_animate_item(item, 0.3)
	
func _animate_item(item : Node, animationLength : float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(item, "position", Vector2(0, -Constants.TILE_SIZE), animationLength).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	tween.kill()
	_kill_item(item, 1)
	
func _kill_item(item : Node, delay : float) -> void:
	await get_tree().create_timer(delay).timeout
	if item != null:
		item.queue_free()
