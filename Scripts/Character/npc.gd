class_name NPC
extends Area2D

@export var npcName := " "
@export var dialogue = []
@export var dialogueAction: Array[bool] = []
@export var action: = []
@export var finishedDialogue: String
@export var attackedDialogue: String
@export var attackedScript: runAction
@export var annoyedDialogue: String
@export var snap : bool = true
@export var destructible : bool = false

enum runAction {nothing = 0, move = 1, spawnItem = 2, changeSprite = 3}

@export var changeSprite: Texture2D

@onready var dialogueTimer = $DialogueTimer
@onready var textBox = $"../../CanvasLayer/UI/Textbox"
@onready var uiText = $"../../CanvasLayer/UI/Textbox/Text"
@onready var textName = $"../../CanvasLayer/UI/Textbox/Name"
@onready var cursor = $"../../CanvasLayer/UI/Textbox/Cursor"

var interactionCount := 0
var shouldDoFinishedDialogue : bool = false
var cancelled : bool = false
var incomplete: bool = false
var destroyed: bool = false
var completed: bool = false

func _ready() -> void:
	if snap == true:
		position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
		@warning_ignore("integer_division")
		position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	if Constants.DestroyedNPCs.has(npcName):
		destroy()
	if Constants.InteractedNPCs.has(npcName):
		interactionCount = Constants.InteractionCount[Constants.InteractedNPCs.find(npcName)]

func _process(_delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _interact() -> void:
	if destroyed == true:
		_hide_text()
		return
	if incomplete == true:
		_skip_text()
		return
	elif interactionCount < dialogue.size() && Constants.CompletedNPCs.has(npcName) == false:
		if Constants.InteractedNPCs.has(npcName) != true:
			Constants.InteractedNPCs.insert(Constants.InteractedNPCs.size(), npcName)
			print("DEBUG >> NPC: " + npcName + " added at index: " + str(Constants.InteractedNPCs.find(npcName)))
			Constants.InteractionCount.insert(Constants.InteractionCount.size(), interactionCount)
			print("DEBUG >> NPC: " + npcName + " Interactions at: " + str(Constants.InteractionCount[Constants.InteractedNPCs.find(npcName)]))
		$"../Player".inDialogue = true
		# Show the widget when displaying new text
		# Destroy any spawned objects, they're only meant to display for one dialogue turn
		if self.get_child_count() > 1:
			for child in self.get_children():
				if child.is_in_group("spawnedItem"):
					child.queue_free()
		if dialogueAction[interactionCount] == true:
			_checkActions()
		# Call the draw text function with the current dialogue
		_draw_text(dialogue[interactionCount])
		# Display next line next interaction
	elif shouldDoFinishedDialogue == false && $"../Player".inDialogue == true:
		shouldDoFinishedDialogue = true
		$"../Player".inDialogue = false
		completed = true
		if Constants.CompletedNPCs.has(npcName) == false:
			Constants.CompletedNPCs.insert(Constants.CompletedNPCs.size(), npcName)
			print("DEBUG >> NPC: " + npcName + " is completed")
		_hide_text()
	elif $"../Player".inDialogue == false && finishedDialogue != null:
		$"../Player".inDialogue = true
		_draw_text(finishedDialogue)
		shouldDoFinishedDialogue = false
	else:
		_hide_text()
		
func _spawn_item(_location: Vector2, item: PackedScene) -> void:
	$"../Player".MOVECOOLDOWN.paused = true
	print("DEBUG >> Item instantiated: " + str(item))
	$"../Player"._get_item(item)
	await get_tree().create_timer(1.5).timeout
	$"../Player".MOVECOOLDOWN.paused = false

func _draw_text(text: String) -> void:
	cursor.visible = false
	cancelled = false
	uiText.visible_characters = 0
	incomplete = true
	textBox.visible = true
	textName.text = npcName
	uiText.text = text
	
	# Set it to be invisible to start
		
	for i in text.length():
		if cancelled == false:
			await get_tree().create_timer(0.04).timeout
			uiText.visible_characters = (i + 1) 
			if uiText.visible_characters == text.length():
				incomplete = false
				cursor.visible = true
				if Constants.InteractedNPCs.has(npcName) == true && interactionCount != dialogue.size():
					interactionCount += 1
					Constants.InteractionCount[Constants.InteractedNPCs.find(npcName)] = interactionCount
					print("DEBUG >> NPC: " + npcName + " Interactions at: " + str(Constants.InteractionCount[Constants.InteractedNPCs.find(npcName)]))

func _hide_text() -> void:
	textBox.visible = false
#
func _skip_text () -> void:
	incomplete = false
	cancelled = true
	textBox.visible = true
	cursor.visible = true
	await get_tree().create_timer(0.05).timeout
	uiText.visible_characters = 128
	if Constants.InteractedNPCs.has(npcName) == true && interactionCount != dialogue.size():
		interactionCount += 1
		Constants.InteractionCount[Constants.InteractedNPCs.find(npcName)] = interactionCount
		print("DEBUG >> NPC: " + npcName + " Interactions at: " + str(Constants.InteractionCount[Constants.InteractedNPCs.find(npcName)]))

func _checkActions() -> void:
		match action[interactionCount][0]:
			runAction.move:
				pass
			runAction.spawnItem:
				_spawn_item(global_position, action[interactionCount][1])
			runAction.changeSprite:
				$"Sprite2D".texture = changeSprite

func _attack() -> void:
	$"../Player".inDialogue = true
	_draw_text(attackedDialogue)
	shouldDoFinishedDialogue = false
	destroy()
	
func destroy() -> void:
	if Constants.DestroyedNPCs.has(npcName) != true:
		Constants.DestroyedNPCs.insert(Constants.DestroyedNPCs.size(), npcName)
	if destructible == true:
		destroyed = true
	match attackedScript:
		runAction.move:
			pass
		runAction.spawnItem:
			_spawn_item(global_position, action[interactionCount][1])
		runAction.changeSprite:
			$"Sprite2D".texture = changeSprite
