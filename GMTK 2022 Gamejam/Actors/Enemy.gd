extends "res://Actors/Entity.gd"

func _ready() -> void:
	SPEED = 30
	DAMAGE = 1
	movetimer = 10
	movetimer_length = 100

func _physics_process(delta):
	movement_loop()
	damage_loop()
	loop_follow_target()
