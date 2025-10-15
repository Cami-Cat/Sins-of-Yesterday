extends Control
class_name UserInterface

@onready var textbox = $Textbox
@onready var text = $Textbox/Text
@onready var cursor = $Textbox/Cursor
@onready var npcName = $Textbox/Name
@onready var blackBar = $"Black Bar"
@onready var credits = $Credits

var incomplete : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Constants.UI = self

func _write_to_screen(textToWrite : String, nameToWrite : String) -> void:
	if incomplete == false:
		_draw_text(textToWrite, nameToWrite)
	else:
		_skip_text()

func _hide_from_screen() -> void:
	textbox.visible = false
	Constants.player.attacking = false
	Constants.player.canMove = true

func _draw_text(textToWrite : String, nameToWrite : String) -> void:
	if textToWrite.length() != 0:
		text.visible_characters = 0
		text.text = textToWrite
		npcName.text = nameToWrite
		_start_write()
		for i in textToWrite.length():
			if incomplete == true:
				await get_tree().create_timer(0.04).timeout
				text.visible_characters = (i + 1) 
				if text.visible_characters == textToWrite.length():
					_end_write()
	else:
		_hide_from_screen()

func _skip_text() -> void:
	incomplete = false
	await get_tree().create_timer(0.04).timeout
	text.visible_characters = -1
	cursor.visible = true
	Constants.player.canMove = false

func _start_write() -> void:
	Constants.player.canMove = false
	incomplete = true
	cursor.visible = false
	textbox.visible = true
	
func _end_write() -> void:
	incomplete = false
	cursor.visible = true
