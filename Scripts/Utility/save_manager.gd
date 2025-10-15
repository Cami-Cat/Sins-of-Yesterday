extends Node

const SAVE_PATH := "res://save.ini"

@onready var parent = self.get_parent()
var file : ConfigFile

func _init_save() -> void:
	pass

func save():
	file = ConfigFile.new()
	_init_save()
	_save_player()
	_save_quests()

func _save_player() -> void:
	var player = Constants.player
	var currLevel = player.get_parent()

	file.set_value("Player", "Current Level Name", currLevel.name)
	file.set_value("Player", "Current Level Path", currLevel.scene_file_path)
	file.set_value("Player", "Position", player.global_position)

func _save_quests() -> void:
	file.set_value("Quests", "Available Quests", Quest_Manager.availableQuests)
	print("Available Quests Saved: " + str(Quest_Manager.availableQuests))
	file.set_value("Quests", "Started Quests", Quest_Manager.startedQuests)
	print("Started Quests Saved: " + str(Quest_Manager.startedQuests))
	file.set_value("Quests", "Completed Quests", Quest_Manager.completedQuests)
	print("Completed Quests Saved: " + str(Quest_Manager.completedQuests))
	
	var error := file.save(SAVE_PATH)
	if error:
		print("ERROR >> [save] an error occurred while saving quest data  [" + str(error) + "]")

func _load_save():
	file = ConfigFile.new()
	var error := file.load(SAVE_PATH)
	if error:
		print("ERROR >> [load] an error occurred while loading quest data [" + str(error) + "]")

	_load_player()
	_load_quests()

func _load_player() -> void:
	var levelPath = file.get_value("Player", "Current Level Path")
	get_tree().change_scene_to_file(levelPath)
	var scene = get_tree().current_scene
	var playerPos = file.get_value("Player", "Position")
	var player = Constants.player
	player.global_position = playerPos

func _load_quests() -> void:
	var arr = file.get_value("Quests", "Available Quests")
	Quest_Manager.availableQuests = arr
	print("Available Quests Loaded: " + str(Quest_Manager.availableQuests))
	arr = file.get_value("Quests", "Started Quests")
	Quest_Manager.startedQuests = arr
	print("Started Quests Loaded: " + str(Quest_Manager.startedQuests))
	arr = file.get_value("Quests", "Completed Quests")
	Quest_Manager.completedQuests = arr
	print("Completed Quests Loaded: " + str(Quest_Manager.completedQuests))
