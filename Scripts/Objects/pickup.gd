extends Area2D
class_name Pickup

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

enum type {HEALTH, CURRENCY, MAX_HEALTH}

@export var pickupID : int
@export var amount : int
@export var pickupType : type = type.HEALTH
@export var pickupScript : Script

func _ready() -> void:
	
	if Constants.pickupsPicked.has(pickupID):
		print("PICKUP >> [" + self.name + "] was already picked up in level: [" + str(get_tree().current_scene) + "]")
		queue_free()
	
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	@warning_ignore("integer_division")
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	
	match pickupType:
		type.HEALTH:
			sprite.texture = load("res://Assets/Sprites/Utility/Health_Full.png")
		type.MAX_HEALTH:
			sprite.texture = load("res://Assets/Sprites/Utility/Health_Full.png")

func _on_pickup() -> void:
	match pickupType:
		type.HEALTH:
			if (Constants.health + amount) <= Constants.maxHealth:
				Constants.health += amount
				Constants.healthManager._update_health()
		type.CURRENCY:
			Constants.currency += amount
		type.MAX_HEALTH:
			Constants.maxHealth += amount
			Constants.healthManager._update_health()
	Constants.pickupsPicked.append(pickupID)
	queue_free()
