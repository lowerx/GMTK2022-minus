extends "res://Actors/Entity.gd"

# ready function lets us set "constants" when the file loads
func _ready():
	SPEED = 100
	TYPE = "PLAYER"
	DAMAGE = 1

# _physics_process is called by the game engine
func _physics_process(delta):
	controls_loop()
	movement_loop()
	spritedir_loop()
	damage_loop()

	#if movedir == Vector2.ZERO:
		#anim_switch("idle")
	#else:
		#anim_switch("walk")

# controls_loop looks for player input
func controls_loop():
	var LEFT                = Input.is_action_pressed("Left")
	var RIGHT       = Input.is_action_pressed("Right")
	var UP          = Input.is_action_pressed("Up")
	var DOWN                = Input.is_action_pressed("Down")

	# By adding our values together, we make it so that one key
	# stroke does not take precidence over another, i.e. pushing
	# left and right keys at the same time
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
