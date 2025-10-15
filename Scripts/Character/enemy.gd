extends Area2D
class_name Enemy

@onready var tileMap = get_parent()
var astarGrid: AStarGrid2D

var originalPos
var desiredPos

func _ready() -> void:
	
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	@warning_ignore("integer_division")
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	
	# Create and define the bounds of the grid, set it to use the size of the tilemap set in the
	# Constants.gd script. Disable diagnoal movement as that is against our goal
	# Then force update so that the grid now has these settings.
	astarGrid = AStarGrid2D.new()
	astarGrid.region = tileMap.get_used_rect()
	astarGrid.cell_size = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.update()
	# Define the region size and position, then loop over each tile and ensure that it is
	# empty, allow the enemy to walk over it.
	var regionSize = astarGrid.region.size
	var regionPos = astarGrid.region.position
	
	for x in regionSize.x:
		for y in regionSize.y:
			var tilePos = Vector2i(x + regionPos.x, y + regionPos.y)
			
			var tileData = tileMap.get_cell_tile_data(tilePos)
			
			# If the tile is emtpy, make it walkable.
			if tileData != null:
				astarGrid.set_point_solid(tilePos, true)

func _move():
	
	if Constants.player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("Enemies")
	var enemyPos = []
	
	for enemy in enemies:
		if enemy == self:
			continue

		enemyPos.append(tileMap.local_to_map(enemy.global_position))
	
	# Cache enemy positions
	for pos in enemyPos:
		astarGrid.set_point_solid(pos, true)
	
	# Generate Path
	var path = astarGrid.get_id_path(
		tileMap.local_to_map(global_position),
		tileMap.local_to_map(Constants.player.global_position)
	)
	
	path.pop_front()
	if path.is_empty():
		print("VERBOSE >> Enemy cannot find path, this is either an error or the player is dead, refer to 'DEATH' log")
		return
	
	originalPos = Vector2(global_position)
	desiredPos = tileMap.map_to_local(path[0])

	if desiredPos == Constants.player.global_position:
		Constants.player._take_damage(1, self)
		await get_tree().create_timer(0.1).timeout
		var tween = create_tween()
		tween.tween_property(self, "global_position", desiredPos, 0.1).set_trans(tween.TRANS_LINEAR)
		tween.tween_property(self, "global_position", originalPos, 0.1).set_trans(tween.TRANS_LINEAR)
		return
	
	# Remove previous enemy positions
	for pos in enemyPos:
		astarGrid.set_point_solid(pos, false)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", desiredPos, 0.1).set_trans(tween.TRANS_LINEAR)

func _attacked():
	_die()

func _die() -> void:
	var flicker : int = 10 # number of times to flicker
	var flickerArr = []
	flickerArr.resize(flicker)
	flickerArr.fill(flicker)
	var sprite = $Sprite2D
	var level = get_tree().current_scene as Level
	var me = level.enemies.find(self)
	level.enemies.remove_at(me)
	for i : int in flickerArr:
		await get_tree().create_timer(0.025).timeout
		if sprite.visible == false:
			sprite.visible = true
		elif sprite.visible == true:
			sprite.visible = false
	queue_free()
