extends KinematicBody2D

var vec = Vector2()
var speed = 175
var canMove = false
var status_effect = -1
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
		vec = Vector2(speed,0).rotated(rotation)


func _on_Timer_timeout():
	queue_free()


func _on_CollisionsEnabledTimer_timeout():
	$CollisionShape2D.disabled = false

#We need to add a small delay for when the pebble starts moving.
func _on_LastTimerISwear_timeout():
	visible = true
	look_at(get_global_mouse_position())
	canMove = true
