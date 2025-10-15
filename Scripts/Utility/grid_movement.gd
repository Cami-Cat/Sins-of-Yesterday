extends Node2D
class_name GridMovement

@warning_ignore("unused_signal")
signal moved

@export var self_node : Node2D
@export var speed := 0.1
@onready var cast = $RayCast2D
@onready var attackManager : AttackHandler = $AttackHandler
@onready var sound = $Move

var movement : Vector2
var moving = Vector2.ZERO
var player : CharacterBody2D
var sprite : String

var playSound = load("res://Assets/Audio/click (1).wav")

func _ready():
	player = self.get_parent()
	cast.target_position = Vector2.DOWN * Constants.TILE_SIZE
	_look_direction(Constants.looking, false)

func move(direction: Vector2) -> void:
	if moving.length() == 0 && direction.length() > 0: 
		if direction.y < 0: 
			_look_direction(Constants.dir.up, true)
		elif direction.x > 0: 
			_look_direction(Constants.dir.right, true)
		elif direction.y > 0: 
			_look_direction(Constants.dir.down, true)
		elif direction.x < 0: 
			_look_direction(Constants.dir.left, true)

		# Rotate (scale) the ray in the direction of travel and force an update
		cast.target_position = movement * Constants.TILE_SIZE
		cast.force_raycast_update()

		# Make sure to only run movement code if the ray is not colliding
		if !cast.is_colliding():
			_move_player(movement, speed)
		else:
			_check_collision()

func _hide_sprites() -> void:
	for i in player.sprites:
		i.visible = false
		
func _look_direction(looking : Constants.dir, playerVis : bool) -> void:
	var sprites = self.get_parent().find_child("Sprites")
	match looking:
		Constants.dir.up:
			movement = Vector2.UP#
			attackManager.weaponFacing = movement
			_edit_sprite_values(playerVis, sprites.find_child("Up"), Constants.dir.up)
		Constants.dir.left:
			movement = Vector2.LEFT
			attackManager.weaponFacing = movement
			_edit_sprite_values(playerVis, sprites.find_child("Left"), Constants.dir.left)
		Constants.dir.right:
			movement = Vector2.RIGHT
			attackManager.weaponFacing = movement
			_edit_sprite_values(playerVis, sprites.find_child("Right"), Constants.dir.right)
		Constants.dir.down:
			movement = Vector2.DOWN
			attackManager.weaponFacing = movement
			_edit_sprite_values(playerVis, sprites.find_child("Down"), Constants.dir.down)

func _edit_sprite_values(playerVis : bool, sprite : AnimatedSprite2D, looking : Constants.dir):
	_hide_sprites()
	var visibleSprite : int = player.sprites.find(sprite)
	if playerVis == true:
		#player.sprites[index].visible = true
		player.sprites[visibleSprite].visible = true
	Constants.looking = looking
	
func _move_player(movementDir : Vector2, moveSpeed : float) -> void:
	sound.stream = playSound
	sound.play()
	player.canMove = false
	player.inDialogue = false
	var new_position = self_node.global_position + (movementDir * Constants.TILE_SIZE)

	var tween = create_tween()
	tween.tween_property(self_node, "position", new_position, moveSpeed).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func(): moving= Vector2.ZERO)
	
	await tween.finished
	tween.kill()
	
	emit_signal("moved", new_position)


func _check_collision() -> void:
	var collision = cast.get_collider()
	if collision is Entrance:
		var entrance = collision
		_move_player(movement, 0.3)
		await get_tree().create_timer(0.3).timeout
		entrance._activate()
		return
	elif collision is Pickup:
		var pickup = collision
		_move_player(movement, 0.1)
		await get_tree().create_timer(0.1).timeout
		pickup._on_pickup()
	elif collision is Event_Trigger:
		var trigger = collision
		_move_player(movement, 0.1)
		player.canMove = false
		await get_tree().create_timer(0.1).timeout
		trigger._execute_events()
	else:
		sound.stream = load("res://Assets/Audio/error.wav")
		sound.play()
		Constants.player.emit_signal("action")
