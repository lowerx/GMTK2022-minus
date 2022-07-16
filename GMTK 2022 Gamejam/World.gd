extends Node2D

onready var tiles = $"Background TileMap"
onready var blocks = $"PhysicalLayer Tilemap"
var xHeight = 0
var yHeight = 0 
onready var player = $Player
var playerCoordinates = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#randomize()
	#xHeight = floor(rand_range(15,20))
	#yHeight = floor(rand_range(10,15))
	#$Camera2D.zoom.x = xHeight * 0.04
	#$Camera2D.global_position.x += 15.40 * xHeight
	#$Camera2D.zoom.y = yHeight * 0.06
	#$Camera2D.global_position.y += 15.3 * yHeight
	#for y in yHeight:
		#y += 1
		#for x in xHeight:
			#if x != 0:
				#tiles.set_cell(x,y,0)
			#else:
				#tiles.set_cell(x,y,1)
			#if y == 1:
				#if x == 0:
					#tiles.set_cell(x,y,2)
				#else:
					#tiles.set_cell(x,y,3)
			#if x == xHeight - 1:
				#if y != yHeight:
					#tiles.set_cell(x,y,5)
				#else:
					#tiles.set_cell(x,y,6)
			#if y == 1 and x == xHeight - 1:
				#tiles.set_cell(x,y,4)
			#if y == yHeight:
				#if x != xHeight - 1:
					#tiles.set_cell(x,y,7)
				#if x == 0:
					#tiles.set_cell(x,y,8)
			#x += 1
	#blocks.set_cell(floor(rand_range(10,xHeight)), floor(rand_range(5,yHeight)),0)
	#blocks.set_cell(floor(rand_range(10,xHeight)), floor(rand_range(5,yHeight)),0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(playerCoordinates)
	playerCoordinates = blocks.world_to_map(player.global_position)
	playerCoordinates.x = floor(playerCoordinates.x / 3 - 1) + 1
	playerCoordinates.y = floor(playerCoordinates.y / 3)
	$Camera2D.global_position = player.global_position
	if blocks.get_cell(playerCoordinates.x,playerCoordinates.y) == 10:
		$Dice.visible = true
		randomize()
		var cheese = floor(rand_range(1,7))
		for x in cheese:
			$Dice.get_child(x).visible = true
		$Dice/RichTextLabel.text = "Rolled: " + str(cheese)
		blocks.set_cell(playerCoordinates.x,playerCoordinates.y,-1)
