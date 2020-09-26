extends CollisionShape2D

#export var torque := 10000.0
export var force := 200.0
export var input : String = "ui_up"
var move_distance = 30

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(input):
		
		var space_state = get_world_2d().direct_space_state
		var ray_start = global_position + Vector2.LEFT.rotated(get_rot()) * self.shape.radius
		var result = space_state.intersect_ray( # cast from the left side of the collider
			ray_start,
			ray_start + Vector2.DOWN.rotated(get_rot()) * move_distance,
			[get_parent()])
		if result.empty(): # otherwise, try again from the right side
			ray_start = global_position + Vector2.RIGHT.rotated(get_rot()) * self.shape.radius
			result = space_state.intersect_ray(
			ray_start,
			ray_start + Vector2.DOWN.rotated(get_rot()) * move_distance,
			[get_parent()])
		if !result.empty():
			print((global_position - result.position).length())
			var parent : RigidBody2D = get_parent()
			#parent.add_torque(torque)
			parent.apply_impulse(position, Vector2.UP.rotated(get_rot()) * force)
		
		position += position.normalized() * move_distance

	if Input.is_action_just_released(input):
		position -= position.normalized() * move_distance


func get_rot():
	return fmod(get_parent().rotation + rotation, 2*PI)
