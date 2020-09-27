extends RigidBody2D


# camera stuff

func get_size():
	return get_viewport().size.x

func get_end():
	return position.x + get_size() / 2

func get_start():
	return position.x - get_size() / 2

# fart stuff

export var base_boost = 250
export var charge_time = 2
export var max_multiplier = 2 - 1
export var cooldown = 3
var _last_usage = -cooldown
var _charge_start

func _physics_process(delta):
	if Input.is_action_just_pressed("fart") && _last_usage + cooldown < OS.get_ticks_msec()/1000:
		_charge_start = OS.get_ticks_msec()/1000.0
	
	if Input.is_action_just_released("fart") && _charge_start != -1:
		_last_usage = OS.get_ticks_msec()/1000
		var multiplier = (min(((OS.get_ticks_msec()/1000.0 - _charge_start) / charge_time), 1)) * max_multiplier + 1
		_charge_start = -1
		var particles : Particles2D = preload("res://scenes/sheep/fart_particles.tscn").instance()
		particles.position.x = $MainCol.shape.radius
		particles.amount *= multiplier
		self.add_child(particles)
		
		self.apply_central_impulse(Vector2.LEFT.rotated(rotation) * base_boost * multiplier)
