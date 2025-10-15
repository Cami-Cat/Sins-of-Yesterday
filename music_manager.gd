extends Node
class_name Music_Manager

@export var currentMusic : AudioStream
@onready var music : AudioStreamPlayer2D = $Music

func _play_music(newMusic : AudioStream) -> void:
	if newMusic.resource_path == currentMusic.resource_path:
		return
	currentMusic = newMusic
	music.stream = newMusic
	music.play()
