extends Sprite2D
class_name Sword

@onready var sound = $Sound
var weapon = self
var soundPlay = load("res://Assets/Audio/secret swoosh.wav")

# Animation handling
func _ready():
	sound.stream = soundPlay

func _play_weapon_anim(movement):
	
	sound.play()
	visible = true
	var atktween = create_tween()
	atktween.tween_property(weapon, "offset", ((movement * Constants.TILE_SIZE)), 0.15).set_trans(Tween.TRANS_LINEAR)
	await atktween.finished
	atktween.kill()
	var rottween = create_tween()
	rottween.tween_property(weapon, "global_rotation", (weapon.global_rotation + deg_to_rad(90)), 0.1).set_trans(Tween.TRANS_LINEAR)
	await rottween.finished
	rottween.kill()
	var rtrntween = create_tween()
	rtrntween.tween_property(weapon, "offset", Vector2(0,0), 0.1).set_trans(Tween.TRANS_LINEAR)
	# rtrntween.tween_property(weapon, "rotation", (weapon.rotation + deg_to_rad(-45)), 0.1).set_trans(Tween.TRANS_LINEAR)
	await rtrntween.finished
	rtrntween.kill()
	visible = false
	
	return

# Hit enemy?
