extends KinematicBody2D

onready var player = get_node("/root/World/Player")
onready var Main = get_node("/root/World")

# "CONSTANTS"
export var SPEED = 0
export var TYPE = "ENEMY"
# have to declare damage here so we can set it in the child scripts
onready var DAMAGE = null

# MOVEMENT
var movedir = Vector2.ZERO
var knockdir = Vector2.ZERO
var spritedir = "down"
var movetimer = 0
var movetimer_length = 0
var movetimer_range
var movetarget_radius
var movetarget_radius_range
var rng = RandomNumberGenerator.new()

var hitstun = 0
var health = 1


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


	# move_and_slide takes care of collisions and has you slide
	# along walls that are blocking your path
	move_and_slide(motion, Vector2.ZERO)

func spritedir_loop():
	
	# For when we have a character sprite
	
	match movedir:
		Vector2.LEFT:
			spritedir = "left"
		Vector2.RIGHT:
			spritedir = "right"
		Vector2.UP:
			spritedir = "up"
		Vector2.DOWN:
			spritedir = "down"

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

	# for any body that is overlapping the entity's hitbox
	for body in $HitBox.get_overlapping_bodies():
		# if the entity isn't already hit, and the body gives damage,
		# and the body is a different type that the entity
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			# decrease health by the body's damage
			health -= body.get("DAMAGE")
			# Set the hitstun timer
			hitstun = 10
			# set knockdir to the opposite of the entity approached
			# the body from
			knockdir = transform.origin - body.transform.origin

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

func reset_movetimer(flag_list = []):
	if movetimer_range and not "ignore_range" in flag_list:
		# return a random number between movetimer_range[0] and movetimer_range[1] inclusive
		movetimer = rng.randi_range(movetimer_range[0], movetimer_range[1])
	else:
		movetimer = movetimer_length

func loop_random_direction(dir_list, flag_list = []):
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		movedir = rand_direction(dir_list)
		reset_movetimer(flag_list)


func loop_follow_target(target = player):
	var multiplier = 0
	if movetimer > 0:
		movetimer -= 1
	if movetimer == 0 || is_on_wall():
		var targetdir = target.global_position - global_position
		movedir = targetdir.normalized()
