extends Node
class_name DialogueScript

enum types {QUEST, NPC, OBJECT, FINISHED, ATTACKED}

@onready var events = self.get_parent().find_child("Events")
@onready var sound = $Sound

@export var dialogueType : types
@export var dialogueStart : int
@export var dialogueEnd : int

@export var dialogueID : int

var soundPlay = load("res://Assets/Audio/jump.wav")
var linesToRead : int
var dialogueCount : int = 0
var currentLine : int = 0

func _ready() -> void:
	sound.stream = soundPlay
	for i in Dialogue_Manager.completed.get_children():
		if i.dialogueID == dialogueID:
			var parent = self.get_parent()
			if parent == Quest:
				var npc = parent.get_parent()
				npc.finishedDialogue = true
			else:
				pass
			print("DIALOGUE >> Quest dialogue of: [" + parent.name + "] is already completed.")
			return
	
	currentLine = dialogueStart
	linesToRead = ((dialogueEnd - dialogueStart))
	
	print("DIALOGUE >> [" + self.name + "] of [" + self.get_parent().name + "] has [" + str(linesToRead) + "] lines to read.")

func _read_dialogue() -> String:

	if Constants.UI.incomplete == true:
		return ""

	if dialogueCount >= linesToRead:
		return _finish_dialogue()

	return _get_current_dialogue()
	
func _execute_event(i) -> void:
	if events == null:
		return
	for event in events.get_children():
		if event.eventStart == i:
			event._on_execute()

func _get_current_dialogue() -> String:
	
	Constants.UI.textbox.visible = true
	var line = Dialogue_Manager.dialogue[currentLine + dialogueCount]
	dialogueCount += 1
	sound.play()
	_execute_event(dialogueCount)
	return line

func _finish_dialogue() -> String:
	
	match dialogueType:
		types.QUEST:
			self.get_parent()._complete_dialogue()
		types.NPC:
			self.get_parent().finishedDialogue = true
		types.FINISHED:
			dialogueCount -= 1
		types.OBJECT:
			self.get_parent()._complete_interaction()
		types.ATTACKED:
			pass
		_:
			pass
	return ""
