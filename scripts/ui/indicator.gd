extends Node2D

onready var _prev_pos = global_position

func set_image(image):
	$Sprite.texture = image

func set_color(color : Color):
	$Border.color = color
	color.a = $Ready.color.a
	$Ready.color = color
	color.a = $Charge.color.a
	$Charge.color = color

func _process(delta):
	global_rotation = 0

func move_towards(pos):
	global_position = _prev_pos + (pos - _prev_pos) * 0.15
	_prev_pos = global_position # avoid being moved by parent

func set_active(status):
	$Ready.color.a = 150.0/255.0 if status else 50.0/255.0
	$Border.invert_border = 4 if status else 2

func ready_progress(percentage):
	$Ready.scale.y = percentage
	$Ready.position.y = (1.0 - percentage) * 32.0
	
