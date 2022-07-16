extends "res://Actors/Entity.gd"

var attackBoxStartPosition
export var attack_time = 0.3
var cooldown = false
onready var attack = preload("res://Pebble_Ammo.tscn")
var AttackCooldown = false
# ready function lets us set "constants" when the file loads
func _ready():
	SPEED = 100
	TYPE = "PLAYER"
	DAMAGE = 1
	attackBoxStartPosition = $AttackBox/CollisionShape2D.position
# _physics_process is called by the game engine
func _physics_process(delta):
	print(health)
	#Attack using LeftClick. Instances attack if there is no longer a cooldown. Attacking only works in world scene.
	if Input.is_action_pressed("LeftClick"):
		if AttackCooldown == false:
			var attackInstance = attack.instance()
			get_parent().add_child(attackInstance)
			attackInstance.global_position = $WeaponSprite.global_position
			$WeaponDelayTimer.start()
			AttackCooldown = true
	movement_loop()
	spritedir_loop()
	damage_loop()
	controls_loop()

	if movedir == Vector2.ZERO:
		anim_switch("idle")
	elif movedir == Vector2.RIGHT:
		anim_switch("walk")
	elif movedir == Vector2.LEFT:
		anim_switch("walk", true)
# controls_loop looks for player input
func controls_loop():
	var LEFT = Input.is_action_pressed("Left")
	var RIGHT = Input.is_action_pressed("Right")
	var UP = Input.is_action_pressed("Up")
	var DOWN = Input.is_action_pressed("Down")
	var ATTACK = Input.is_action_pressed("Attack")
	
	if RIGHT:
		$AttackBox/CollisionShape2D.position.x = attackBoxStartPosition.x
		
	if LEFT:
		$AttackBox/CollisionShape2D.position.x = -attackBoxStartPosition.x
		
	if ATTACK and not cooldown:
		cooldown = true
		$AttackBox/CollisionShape2D.disabled = false
		yield(get_tree().create_timer(attack_time), "timeout")
		$AttackBox/CollisionShape2D.disabled = true
		yield(get_tree().create_timer(attack_time), "timeout")
		cooldown = false

	# By adding our values together, we make it so that one key
	# stroke does not take precidence over another, i.e. pushing
	# left and right keys at the same time
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)

func die():
	get_tree().reload_current_scene()



func _on_WeaponDelayTimer_timeout():
	AttackCooldown = false
