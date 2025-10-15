extends Event
class_name Open_Chest

func _on_execute() -> void:
	var chest = get_parent().get_parent()
	var atlas : AtlasTexture = chest.sprite.texture
	var Arr : Array = [1, 2]
	for i in Arr:
		await get_tree().create_timer(0.3).timeout
		print(atlas.region)
		atlas.region.position.x -= 16 
	
	self.get_parent().remove_child(self)
	Event_Manager.executed.add_child(self)
	emit_signal.call_deferred("executed")
