extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

func _ready() -> void:
	set_attack_enabled(false)


func set_attack_enabled(value):
	$AttackArea/AttackCollision.disabled = value

func move_attack_area_to(amount):
	$AttackArea/AttackCollision.position.x = amount

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("Right"):
		velocity.x += 1
		move_attack_area_to(50)
	if Input.is_action_pressed("Left"):
		velocity.x -= 1
		move_attack_area_to(-50)
	if Input.is_action_pressed("Down"):
		velocity.y += 1
	if Input.is_action_pressed("Up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
