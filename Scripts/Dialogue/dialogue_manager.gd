extends Node
class_name DialogueMan

@onready var dialogue : Array[String]
@onready var language : String = "EN"
@onready var completed : Node = $Completed

func _ready() -> void:
	
	var fileString = ("user://Lang/lang_" + language + ".txt")
	
	if FileAccess.file_exists(fileString) == false:
		print("ERROR >> [DIALOGUE] Lang file: [" + fileString + "] does not exist, setting to default.")
		fileString = ("res://Lang/lang_EN.txt")
	var dialogueFile = FileAccess.open(fileString, FileAccess.READ)
	if !dialogueFile:
		print("ERROR >> [Dialogue] File not found")
		return
	while not dialogueFile.eof_reached():
		var line = dialogueFile.get_line()
		if line.length() != 0: # Ignores the last line of the file.
			dialogue.append(line)
	dialogueFile.close()
	print("DIALOGUE >> file: [" + fileString + "] has: [" + str(dialogue.size()) + "] lines total")

func _dialogue_completed(dialogueIn: Node) -> void:
	print("DIALOGUE >> Dialogue with: [" + dialogueIn.get_parent().name + "] completed, removing from parent.")
	var parentDialogue = dialogueIn.get_parent()
	parentDialogue.remove_child(dialogueIn)
	completed.add_child(dialogueIn)
