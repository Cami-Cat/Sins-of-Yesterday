extends TileMapLayer

@onready var astarGrid = AStarGrid2D.new()
@export var mapSize : Vector2 = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)

var pointPath = []

@onready var obstacles = get_used_cells()
@onready var halfCellSize = Constants.TILE_SIZE / 2

var pathStart
var pathEnd

func _ready():
	var walkableCells = _astar_add_walkable_cells(obstacles)
	_astar_connect_walkable_cells(walkableCells)
	

func _astar_add_walkable_cells(obstacles : Array):
	var pointsArray = []
	for y in range(mapSize.y):
		for x in range(mapSize.x):
			var point = Vector2(x, y)
			if point in obstacles:
				continue
			
			pointsArray.append(point)
			var pointIndex = _calculate_point_index(point)
			astarGrid.add_point(pointIndex, Vector2(point.x, point.y))
	return pointsArray
	
func _astar_connect_walkable_cells(pointsArray):
	for point in pointsArray:
		var pointIndex = _calculate_point_index(point)
		
		var pointsRelative = PackedVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1)])
		for pointRelative in pointsRelative:
			var pointRelativeIndex = _calculate_point_index(pointRelative)
			
			if _is_outside_map_bounds(pointRelative):
				continue
			if not astarGrid.has_point(pointRelativeIndex):
				continue
			
			astarGrid.connect_points(pointIndex, pointRelativeIndex, false)
			

func astar_connect_walkable_cells_diagonal(pointsArray):
	for point in pointsArray:
		var pointIndex = _calculate_point_index(point)
		for localy in range(3):
			for localx in range(3):
				var pointRelative = Vector2(point.x + localx - 1, point.y + localy -1)
				var pointRelativeIndex = _calculate_point_index(pointRelative)
				
				if pointRelative == point or _is_outside_map_bounds(pointRelative):
					continue
				if not astarGrid.has_point(pointRelativeIndex):
					continue
				astarGrid.connect_points(pointIndex, pointRelativeIndex, false)


func _is_outside_map_bounds(point) -> bool:
	return point.x < 0 || point.y < 0 || point.x >= mapSize.x || point.y >= mapSize.y

func _calculate_point_index(point) -> int:
	return (point.x + mapSize.x * point.y)

func _find_path(start, end) -> Array:
	self.pathStart = local_to_map(start)
	self.pathEnd = local_to_map(end)
	_recalculate_path()
	var pathWorld = []
	for point in pointPath:
		var pointWorld = map_to_local(Vector2(point.x, point.y)) + halfCellSize
		pathWorld.append(pointWorld)
	return pathWorld
	
func _recalculate_path() -> void:
	_clear_previous_path_drawing()
	var startIndex = _calculate_point_index(pathStart)
	var endIndex = _calculate_point_index(pathEnd)
	pointPath = astarGrid.get_point_path(startIndex, endIndex)
	astarGrid.update()
	
func _clear_previous_path_drawing() -> void:
	if not pointPath:
		return
	var start = pointPath[0]
	var end = pointPath[len(pointPath) - 1]
	set_cell(start.x, start.y)
	set_cell(end.x, end.y)
