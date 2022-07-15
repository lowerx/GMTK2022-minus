extends Node2D

onready var tiles = $"Background TileMap"
onready var blocks = $"PhysicalLayer Tilemap"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var xHeight = floor(rand_range(10,20))
	var yHeight = floor(rand_range(5,15))
	for y in yHeight:
		y += 1
		for x in xHeight:
			if x != 0:
				tiles.set_cell(x,y,0)
			else:
				tiles.set_cell(x,y,1)
			if y == 1:
				if x == 0:
					tiles.set_cell(x,y,2)
				else:
					tiles.set_cell(x,y,3)
			if x == xHeight - 1:
				if y != yHeight:
					tiles.set_cell(x,y,5)
				else:
					tiles.set_cell(x,y,6)
			if y == 1 and x == xHeight - 1:
				tiles.set_cell(x,y,4)
			if y == yHeight:
				if x != xHeight - 1:
					tiles.set_cell(x,y,7)
				if x == 0:
					tiles.set_cell(x,y,8)
			x += 1
	blocks.set_cell(floor(rand_range(10,xHeight)), floor(rand_range(5,yHeight)),0)
	blocks.set_cell(floor(rand_range(10,xHeight)), floor(rand_range(5,yHeight)),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
