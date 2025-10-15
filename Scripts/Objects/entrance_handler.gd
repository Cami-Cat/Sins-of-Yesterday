extends Area2D
class_name Entrance

@warning_ignore("unused_signal")
signal entered(loc, directionToExit)

@export var pathToLoad: String
@export var loc: Vector2
@export var directionToExit: Vector2

func _ready() -> void:
	# Snap the object to the grid
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	@warning_ignore("integer_division")
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)

func _activate() -> void:
	
	# Set values of the Constant script to call from the level
	
	Constants.entered = true
	Constants.exitDir = directionToExit
	Constants.exitLoc = loc
	# Upon being entered, load the selected level
	get_tree().change_scene_to_file(pathToLoad)
