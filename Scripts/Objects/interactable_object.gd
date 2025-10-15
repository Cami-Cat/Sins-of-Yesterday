extends Node
class_name InteractableObject

@warning_ignore("unused_signal")
signal interaction(pawn)

@onready var dialogue = $Dialogue
@onready var events = $Events
@onready var sprite = $Sprite2D

@export var startEvent : Script
@export var endEvent : Script

var firstInteract : bool = true
var finishedDialogue : bool = false

func _ready() -> void:
	pass

func _interact() -> void:
	if startEvent != null && firstInteract == true:
		startEvent._on_execute()
	firstInteract = false
	Constants.UI._write_to_screen(dialogue._read_dialogue(), self.name)
	emit_signal("interaction", self)

func _complete_interaction() -> void:
	Dialogue_Manager._dialogue_completed(dialogue)
	dialogue = $FinishedDialogue
	if endEvent != null:
		endEvent._on_execute()
