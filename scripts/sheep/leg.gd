extends CollisionShape2D

export var torque := 5000.0
export var force := 200.0
export var force_in_air = 10
export var input : String = "ui_up"
export var cooldown = 0.2
var move_distance = 40

export var indicator_image : Texture
export var indicator_color : Color

var _last_usage = 0
var _is_active = false
var _indicator : Node2D

func _ready():
	_indicator = preload("res://scenes/menus/Indicator.tscn").instance()
	self.add_child(_indicator)
	_indicator.global_position = target_indicator_position()
	_indicator.scale = Vector2(0.7, 0.7)
	_indicator.set_image(indicator_image)
	_indicator.set_color(indicator_color)


func _process(delta): # update indicator
	# smooth movement
	_indicator.move_towards(target_indicator_position())
	
	# display recharge
	if !_is_active:
		var percentage = min((OS.get_ticks_msec()/1000.0 - _last_usage) / cooldown, 1.0)
		_indicator.ready_progress(percentage)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(input) && _last_usage + cooldown < OS.get_ticks_msec()/1000:
		_last_usage = OS.get_ticks_msec()/1000
		_is_active = true
		_indicator.set_active(true)
		
		var space_state = get_world_2d().direct_space_state
		var ray_start = global_position + Vector2.LEFT.rotated(get_rot()) * self.shape.radius
		var result_left = space_state.intersect_ray( # cast from the left side of the collider
			ray_start,
			ray_start + Vector2.DOWN.rotated(get_rot()) * (move_distance + self.shape.height + self.shape.radius),
			[get_parent()])
		# try again from the right side
		ray_start = global_position + Vector2.RIGHT.rotated(get_rot()) * self.shape.radius
		var result_right = space_state.intersect_ray(
			ray_start,
			ray_start + Vector2.DOWN.rotated(get_rot()) * (move_distance + self.shape.height + self.shape.radius),
			[get_parent()])
		var parent : RigidBody2D = get_parent()
		var distance_to_obstacle = -1 #not utilized, but may be useful for proportional force
		if !result_left.empty() and !result_right.empty():
			distance_to_obstacle = min(
				(ray_start - result_left.position).length(),
				(ray_start - result_right.position).length())
		elif !result_left.empty() or !result_right.empty():
			var result = result_left or result_right
		if distance_to_obstacle != -1:
			# print(distance_to_obstacle)
			parent.apply_torque_impulse(Vector2.UP.rotated(get_rot()).angle_to(Vector2(0, 1)) * torque)
			parent.apply_central_impulse(Vector2.UP.rotated(get_rot()) * force)
		else:
			parent.apply_impulse(position, Vector2.UP.rotated(get_rot()) * force_in_air)
		
		position += position.normalized() * move_distance

	if Input.is_action_just_released(input) && _is_active:
		_is_active = false
		_indicator.set_active(false)
		position -= position.normalized() * move_distance


func get_rot():
	return fmod(get_parent().rotation + rotation, 2*PI)

func target_indicator_position():
	return global_position + Vector2.DOWN.rotated(global_rotation) * 100
