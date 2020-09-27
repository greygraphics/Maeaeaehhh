extends RigidBody2D


# camera stuff

func get_size():
	return get_viewport().size.x

func get_end():
	return global_position.x + get_size() / 2

func get_start():
	return global_position.x - get_size() / 2

# fart stuff

export var base_boost = 250
export var charge_time = 2
export var max_multiplier = 2 - 1
export var cooldown = 3
var _last_usage = -cooldown
var _charge_start = -1 # -1 = not charging

var _indicator : Node2D

export var indicator_image : Texture
export var indicator_color : Color

# roll stuff
export var base_roll = 5000
export var roll_charge_time = 2
export var roll_max_multiplier = 10 - 1
export var roll_cooldown = 4
var _roll_last_usage = -roll_cooldown
var _roll_charge_start = -1

var _roll_indicator: Node2D
export var roll_indicator_image: Texture
export var roll_indicator_color: Color

func _ready():
	_indicator = preload("res://scenes/menus/Indicator.tscn").instance()
	self.add_child(_indicator)
	_indicator.global_position = target_indicator_position(PI/8)
	_indicator.scale = Vector2(0.7, 0.7)
	_indicator.set_image(indicator_image)
	_indicator.set_color(indicator_color)
	
	_roll_indicator = preload("res://scenes/menus/Indicator.tscn").instance()
	self.add_child(_roll_indicator)
	_roll_indicator.global_position = target_indicator_position(-PI/8)
	_roll_indicator.scale = Vector2(0.7, 0.7)
	_roll_indicator.set_image(roll_indicator_image)
	_roll_indicator.set_color(roll_indicator_color)


func _process(delta):
	_indicator.move_towards(target_indicator_position(PI/8))
	_roll_indicator.move_towards(target_indicator_position(-PI/8))
	
	if _charge_start == -1:
		var percentage = min((OS.get_ticks_msec()/1000.0 - _last_usage) / cooldown, 1.0)
		_indicator.ready_progress(percentage)
	else:
		var percentage = min(((OS.get_ticks_msec()/1000.0 - _charge_start) / charge_time), 1)
		_indicator.charge_progress(percentage)
	
	if _roll_charge_start == -1:
		var percentage = min((OS.get_ticks_msec()/1000.0 - _roll_last_usage) / roll_cooldown, 1.0)
		_roll_indicator.ready_progress(percentage)
	else:
		var percentage = min(((OS.get_ticks_msec()/1000.0 - _roll_charge_start) / roll_charge_time), 1)
		_roll_indicator.charge_progress(percentage)

func _physics_process(delta):
	if Input.is_action_just_pressed("fart") && _last_usage + cooldown < OS.get_ticks_msec()/1000.0:
		_charge_start = OS.get_ticks_msec()/1000.0
	
	if Input.is_action_just_released("fart") && _charge_start != -1:
		_last_usage = OS.get_ticks_msec()/1000.0
		var multiplier = (min(((OS.get_ticks_msec()/1000.0 - _charge_start) / charge_time), 1)) * max_multiplier + 1
		_charge_start = -1
		_indicator.charge_progress(0)
		
		var direction = Vector2.RIGHT.rotated(rotation - PI/8).normalized() # bottom left
		var particles : Particles2D = preload("res://scenes/sheep/fart_particles.tscn").instance()
		particles.amount *= multiplier
		particles.position = - Vector2.RIGHT.rotated(- PI/8).normalized() * $MainCol.shape.radius
		self.add_child(particles)
		#particles.rotation = rotation #+ 3/8 * PI
		
		self.apply_central_impulse(direction * base_boost * multiplier)
	
	if Input.is_action_just_pressed("roll") && _roll_last_usage + roll_cooldown < OS.get_ticks_msec()/1000.0:
		_roll_charge_start = OS.get_ticks_msec() / 1000.0
	if Input.is_action_just_released("roll") &&  _roll_charge_start != -1:
		_roll_last_usage = OS.get_ticks_msec()/1000.0
		var multiplier = (min(((OS.get_ticks_msec()/1000.0 - _roll_charge_start) / roll_charge_time), 1)) * roll_max_multiplier + 1
		_roll_charge_start = -1
		_roll_indicator.charge_progress(0)
		apply_torque_impulse(base_roll * multiplier)
		apply_central_impulse(Vector2.UP * 100)


func target_indicator_position(angle):
	return global_position + Vector2.LEFT.rotated(rotation - angle).normalized() * ($MainCol.shape.radius + 100) # bottom left
