extends Control
class_name Health

@onready var healthSprite = $Heart_1
@onready var totalHealth : Array = [healthSprite]

func _ready() -> void:
	Constants.healthManager = self
	var cachedPosition : Vector2 = healthSprite.global_position
	for i in (Constants.maxHealth - 1):
		_increase_max_health()
	_update_health()

func _update_health() -> void:
	if _is_max_health_increased() == true:
		print("HEALTH >> Player has picked up new Max Health, increasing total health and healing to full.")
		for i in totalHealth:
			i.texture = load("res://Assets/Sprites/Utility/Health_Full.png")
			Constants.health = Constants.maxHealth
	else:
		print("HEALTH >> Current health is equal to: " + str(Constants.health))
		for i in totalHealth:
			if (i.get_index() + 1) <= (Constants.health):
				i.texture = load("res://Assets/Sprites/Utility/Health_Full.png")
			else:
				i.texture = load("res://Assets/Sprites/Utility/Health_Empty.png")

func _is_max_health_increased() -> bool:
	if Constants.maxHealth > totalHealth.size():
		var newMax = Constants.maxHealth - totalHealth.size()
		for i in newMax:
			_increase_max_health()
		return true
	else:
		return false

func _increase_max_health() -> void:
	healthSprite = healthSprite.duplicate()
	self.add_child(healthSprite)
	totalHealth.append(healthSprite)
	if (totalHealth.size() - 1) % 10 == 0:
		healthSprite.global_position = (healthSprite.global_position - Vector2((Constants.TILE_SIZE - 3) * 9, -(Constants.TILE_SIZE - 3)))
		return
	healthSprite.global_position = (healthSprite.global_position + Vector2(Constants.TILE_SIZE - 3, 0))
