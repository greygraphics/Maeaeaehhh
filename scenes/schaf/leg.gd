extends Node2D

#export var torque := 10000.0
export var force := 100.0
export var input : String = "ui_up"
var move_distance = 50

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(input):
		var parent : RigidBody2D = get_parent().get_parent()
		#parent.add_torque(torque)
		parent.apply_impulse(position, Vector2.UP.rotated(get_rot()) * force)
		
		position += position.normalized() * move_distance

	if Input.is_action_just_released(input):
		position -= position.normalized() * move_distance


func get_rot():
	return fmod(get_parent().get_parent().rotation + get_parent().rotation, 2*PI)
