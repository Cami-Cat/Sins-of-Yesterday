extends Node
class_name AttackHandler

@onready var movementManager : GridMovement = $".."
@onready var player : CharacterBody2D = $"../.."
@onready var weapon = $Sword
var direction : Vector2

const defaultRotation: = deg_to_rad(-45)
var weaponRotation : float
var weaponFacing : Vector2

func _ready() -> void:
	weapon.visible = false

func _on_attack() -> void:
	var cast = movementManager.cast
	cast.force_raycast_update()
	var collision = cast.get_collider()
	if collision == null:
		return
	if collision.is_in_group("interact"):
		collision._attack()
	elif collision.is_in_group("Enemies"):
		print("Cast is colliding.")
		collision._attacked()

func _attack() -> void:
	_get_player_direction()
	movementManager.cast.force_raycast_update()
	weapon.global_rotation = defaultRotation
	weapon.global_position = player.global_position
	# Prevent the player from acting
	player.attacking = true
	# Play the animation
	_on_attack()
	weapon._play_weapon_anim(direction)
	await get_tree().create_timer(0.35).timeout
	player.attacking = false
	return

func _get_player_direction() -> void:
	match Constants.looking:
		Constants.dir.up:
			weapon.texture = load("res://Assets/Sprites/Objects/sword_sprite.png")
			direction = Vector2(0, -1)
		Constants.dir.left:
			weapon.texture = load("res://Assets/Sprites/Objects/sword_left.png")
			direction = Vector2(-1, 0)
		Constants.dir.down:
			weapon.texture = load("res://Assets/Sprites/Objects/sword_down.png")
			direction = Vector2(0, 1)
		Constants.dir.right:
			weapon.texture = load("res://Assets/Sprites/Objects/sword_right.png")
			direction = Vector2(1, 0)
