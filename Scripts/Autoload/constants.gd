extends Node

# hold the size of tiles for use within maths

const TILE_SIZE := 16

# Entrance handler

var entered: bool = false
var exitLoc: Vector2
var exitDir: Vector2


var currency : int
var player : Node
var UI : Node
var healthManager : Node

var health : int = 2
@export var maxHealth : int = 3

var looking = dir.down

enum dir {up, down, left, right}

# obtained items

var sword: bool = false
var wand: bool = false

var pickupsPicked : Array[int] = []
