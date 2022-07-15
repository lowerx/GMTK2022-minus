extends "res://Actors/Entity.gd"

func _ready() -> void:
	DAMAGE = 1

func _physics_process(delta):
	damage_loop()
