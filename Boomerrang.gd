extends KinematicBody2D

var vec = Vector2()
var speed = 175
var canMove = false
var status_effect = -1
var goBack = false
var damage = 20
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canMove == true:
		move_and_slide(vec)
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision:
				get_parent().get_node("Player/WeaponSprite").visible = true
				queue_free()
	if goBack == true:
		rotation_degrees = 180
		vec = Vector2(0,0)
		global_position += global_position.direction_to(get_parent().get_node("Player").global_position) * speed * delta
func _on_CollisionsEnabledTimer_timeout():
	$CollisionShape2D.disabled = false

#We need to add a small delay for when the pebble starts moving.
func _on_LastTimerISwear_timeout():
	get_parent().get_node("Player/WeaponSprite").visible = false
	visible = true
	look_at(get_global_mouse_position())
	canMove = true
	vec = Vector2(speed,0).rotated(rotation)


func _on_GoBackToPlayer_timeout():
	goBack = true
