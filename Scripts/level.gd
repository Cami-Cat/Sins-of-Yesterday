class_name Level
extends Node2D

# Map

@onready var interactable_map = $"Scene/Mid-Ground"
@onready var player = $"Player"

# UI
@onready var enemies = $"Scene/Mid-Ground".get_children()

@onready var textBox = $CanvasLayer/UI/Textbox
@onready var cursor = $CanvasLayer/UI/Textbox/Cursor
@onready var music = $Music

@export var musicPath : String = ""

var enemyCount

func _ready() -> void:
	
	enemyCount = enemies.size()

	textBox.visible = false
	cursor.play("Bouncing")
	print("DEBUG >> Connecting player signal 'action' to function.")
	Constants.player.connect("action", _move_enemies)
	if Constants.entered == true:
		_on_player_entered(Constants.exitLoc, Constants.exitDir)

	await get_tree().create_timer(0.5).timeout
	var levelMusic : AudioStream = load(musicPath)
	MusicManager._play_music(levelMusic)

func get_tile_coords_from_global_position(pos : Vector2) -> Vector2i:
	if interactable_map != null:
		return interactable_map.local_to_map(interactable_map.to_local(pos))
	else:
		print("ERROR >> No tilemap to reference, please ensure that the tilemap is placed correctly in the hierarchy.")
		return Vector2(0, 0)

func _on_player_entered(loc, directionToExit) -> void:
	player.canMove = false
	player.global_position = loc
	var tween = create_tween()
	tween.tween_property(player, "global_position", (loc + directionToExit), 0.3).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	player.canMove = true
	Constants.entered = false

func _move_enemies():
	
	for enemy in enemies:
		await get_tree().create_timer(0.05).timeout
		enemy._move()
	if player != null:
		player.canMove = true
