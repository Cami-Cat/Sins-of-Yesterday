extends Sprite2D
class_name logo

@export var length : float = 3

var goalRot
var goalScale

func _ready() -> void:
	_timer_timeout()
	
func _timer_timeout() -> void:
	var randomRot : float = randf_range(-10, 10)
	goalRot = deg_to_rad(randomRot)
	var randomScale : float = randf_range(1.9, 2.1)
	goalScale = randomScale
	var RotTween = create_tween()
	RotTween.tween_property(self, "global_rotation", goalRot, length)
	var ScaleTween = create_tween()
	ScaleTween.tween_property(self, "scale", Vector2(goalScale, goalScale), length)
	await ScaleTween.finished
	_timer_timeout()
