extends "res://Actors/Entity.gd"

var chasing_player = false

func _ready() -> void:
	SPEED = 30
	DAMAGE = 1
	movetimer = 100
	movetimer_length = 100
	$anim.play("idle")

func _physics_process(delta):
	if health > 0:
		movement_loop()
		damage_loop()
		if chasing_player:
			loop_follow_target()
		else:
			loop_random_direction(["horizontal", "vertical"])
		
		if health <= 0:
			anim_switch("bonk")
		elif knockdir != Vector2.ZERO:
			anim_switch("damage")
		elif movedir == Vector2.ZERO:
			anim_switch("idle")
		else:
			anim_switch("walk")
	
	spritedir_loop()

func _on_PlayerDetection_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		chasing_player = true


func _on_PlayerDetection_body_exited(body: Node) -> void:
	if body.get_name() == "Player":
		chasing_player = false
