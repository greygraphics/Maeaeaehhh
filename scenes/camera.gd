extends Camera2D


func _process(delta):
	position.x += delta * 100

func get_size():
	return get_viewport().size.x

func get_end():
	return position.x + get_size() / 2

func get_start():
	return position.x - get_size() / 2
