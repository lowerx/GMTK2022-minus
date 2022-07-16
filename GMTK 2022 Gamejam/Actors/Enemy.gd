extends "res://Actors/Entity.gd"

var chasing_player = false

func _ready() -> void:
	SPEED = 50
	DAMAGE = 1
	movetimer = 10
	movetimer_length = 100

func _physics_process(delta):
	movement_loop()
	damage_loop()
	if chasing_player:
		loop_follow_target()
	else:
		loop_random_direction(["horizontal", "diagonal", "vertical"])



func _on_PlayerDetection_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		chasing_player = true


func _on_PlayerDetection_body_exited(body: Node) -> void:
	if body.get_name() == "Player":
		chasing_player = false
