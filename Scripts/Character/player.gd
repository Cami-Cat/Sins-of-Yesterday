extends CharacterBody2D
class_name Player

@onready var sprites : Array = $Sprites.get_children()
@onready var movement = $GridMovement
@onready var moveCooldown = $MovementLimiter
@onready var interaction = $GridMovement/InteractionHandler
@onready var attack = $GridMovement/AttackHandler
@onready var camera = $Camera2D

@warning_ignore("unused_signal")
signal action()
var inDialogue : bool = false
var attacking : bool = false
var canMove : bool = true

# Important functions

func _ready():
	Constants.player = self
	if Constants.player == self:
		print("PLAYER >> Successfully created player.")
	else:
		print("ERROR >> [Player] Could not create player properly, exiting safely.")
		get_tree().quit()
		
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	@warning_ignore("integer_division")
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	
	movement.connect("moved", _moved)
	_check_direction()

func _input(_event: InputEvent) -> void:
	# Has the player JUST pressed any of these buttons?

	#if Input.is_action_just_pressed("Pause"):
		#print("SAVE >> Saving is disconnected, passing.")
		#return
		# SaveManager.save()

		# Saving functions perfectly well, the correct data is stored as it should be,
		# Loading however needs work, and as such it will not be implemented.

	#if Input.is_action_just_pressed("Load"):
		#print("LOAD >> Loading is disconnected, passing")
		#return
		# SaveManager._load_save()
	if _is_any_movement_just_pressed() == true && canMove == true && attacking == false:
		_move()
	
	elif Input.is_action_just_pressed("Interact"):
		if inDialogue != true:
			interaction._on_interact()
			return
		if Constants.UI.incomplete == true:
			Constants.UI._skip_text()
		else:
			Constants.UI._hide_from_screen()
			
	elif Input.is_action_just_pressed("Attack") && Constants.sword == true && inDialogue == false && attacking != true:
		attack._attack()



# Handlers for the functions above



func _is_any_movement_just_pressed() -> bool:
	if Input.is_action_just_pressed("move_up") || Input.is_action_just_pressed("move_down") || Input.is_action_just_pressed("move_right") || Input.is_action_just_pressed("move_left"):
		return true
	else:
		return false

func _move():
	# Hide the widget if the player dares to move while talking to an NPC
	$"../CanvasLayer/UI/Textbox".visible = false
	# prevent the player from moving again
	# Then move the player
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Then tell the game the player has moved
	movement.move(input_direction)	

func _moved(new_position):
	# Tell the game I've moved!
	emit_signal("action")

func _get_item(item: PackedScene):
	match item.resource_path:
		"res://Scenes/Objects/sword.tscn":
			Constants.sword = true
	
	await get_tree().create_timer(2).timeout

func _check_direction() -> void:
	for i in sprites:
		i.play("Idle")
		i.visible = false
	match Constants.looking:
		Constants.dir.down:
			sprites[0].visible = true
		Constants.dir.up:
			sprites[1].visible = true
		Constants.dir.left:
			sprites[2].visible = true
		Constants.dir.right:
			sprites[3].visible = true

# Would typically place this on a component but the player is the only object in the world that will
# have a health system like this, thus I feel there would be no need to make a separate object to handle
# taking damage.

func _take_damage(amount: int, causer) -> void:
	print("DAMAGE >> Player has taken damage, applying knockback.")
	_knockback(causer)
	Constants.health -= amount
	print("DAMAGE >> Lowering health by: " + str(amount))
	if Constants.health <= 0:
		print("DEATH >> Player is dead, caused by: [" + causer.name + "]")
		self.queue_free()
	Constants.healthManager._update_health()

func _knockback(causer) -> void:
	var newDir
	var distance = (causer.global_position - global_position)
	newDir = (distance * - 1)
	movement.cast.target_position = newDir
	movement.cast.force_raycast_update()
	if movement.cast.is_colliding():
		movement.cast.target_position = (distance)
		movement.cast.force_raycast_update()
		return
	var tween = create_tween()
	tween.tween_property(self, "position", (global_position + newDir), 0.05).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	tween.kill()
	movement.cast.target_position = (distance)
	movement.cast.force_raycast_update()
