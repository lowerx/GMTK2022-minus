extends KinematicBody2D

onready var player = get_parent().get_node("Player")

# "CONSTANTS"
export var SPEED = 0
export var TYPE = "ENEMY"
# have to declare damage here so we can set it in the child scripts
onready var DAMAGE = null
onready var HITSTUN = 10

# MOVEMENT
var movedir = Vector2.ZERO
var knockdir = Vector2.ZERO
var spritedir = "down"
var movetimer = 0
var movetimer_length = 0
var movetarget_radius
var movetarget_radius_range
var rng = RandomNumberGenerator.new()

var hitstun = 0
var health = 3


# Putting this here so that we can setup future calls from the
# child scripts and not have them fail
func _ready():
	return

func movement_loop():
	var motion

	# if you aren't in hitstun then move normally
	# otherwise get knocked back
	if hitstun == 0:
		motion = movedir.normalized() * SPEED
	else:
		motion = knockdir.normalized() * SPEED * 1.5
		anim_switch("damage")

	# move_and_slide takes care of collisions and has you slide
	# along walls that are blocking your path
	move_and_slide(motion, Vector2.ZERO)

func spritedir_loop():
	
	# For when we have a character sprite
	
	match movedir:
		Vector2.LEFT:
			spritedir = "_left"
		Vector2.RIGHT:
			spritedir = "_right"
		Vector2.UP:
			spritedir = "_up"
		Vector2.DOWN:
			spritedir = "_down"

# This changes our player animation.  "animation" is a string
# of the sort "idle", "push", or "walk"
func anim_switch(animation):
	var newanim = str(animation, spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)

func damage_loop():
	# If you're in hitstun countdown the timer
	if hitstun > 0:
		hitstun -= 1
		
	if hitstun == 0 and knockdir != Vector2.ZERO:
		knockdir = Vector2.ZERO

	# for any body that is overlapping the entity's hitbox
	for body in $HitBox.get_overlapping_bodies():
		handle_damage(body)
	
	for area in $HitBox.get_overlapping_areas():
		handle_damage(area.get_parent())

func handle_damage(body):
	# if the entity isn't already hit, and the body gives damage,
	# and the body is a different type that the entity
	if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			# decrease health by the body's damage
			health -= body.get("DAMAGE")
			
			anim_switch("damage")
			
			if health <= 0:
				die()
			
			# Set the hitstun timer
			hitstun = HITSTUN
			# set knockdir to the opposite of the entity approached
			# the body from
			knockdir = transform.origin - body.transform.origin

func die():
	anim_switch("bonk")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


func rand_direction(dir_list):
	var random_dir_list = []
	if "horizontal" in dir_list:
		random_dir_list.append(Vector2.LEFT)
		random_dir_list.append(Vector2.RIGHT)
	if "vertical" in dir_list:
		random_dir_list.append(Vector2.UP)
		random_dir_list.append(Vector2.DOWN)
	if "diagonal" in dir_list:
		random_dir_list.append(Vector2.LEFT + Vector2.UP)
		random_dir_list.append(Vector2.RIGHT + Vector2.UP)
		random_dir_list.append(Vector2.LEFT + Vector2.DOWN)
		random_dir_list.append(Vector2.RIGHT + Vector2.DOWN)

	var index = randi() % random_dir_list.size()
	# return a random element from the list
	return(random_dir_list[index])

func reset_movetimer():
	movetimer = movetimer_length

func loop_random_direction(dir_list):
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0:
		movedir = rand_direction(dir_list)
		reset_movetimer()


func loop_follow_target(target = player):
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0:
		
		var xdif = target.global_position.x - global_position.x
		var ydif = target.global_position.y - global_position.y
		
		if xdif > 0 and abs(xdif) >= abs(ydif):
			movedir = Vector2.RIGHT
		elif xdif < 0 and abs(xdif) >= abs(ydif):
			movedir = Vector2.LEFT
		elif ydif > 0 and abs(ydif) >= abs(xdif):
			movedir = Vector2.DOWN
		elif ydif < 0 and abs(ydif) >= abs(xdif):
			movedir = Vector2.UP
		
		reset_movetimer()
