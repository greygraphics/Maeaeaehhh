extends Node2D


func get_size():
	var shape = get_node("Body/CollisionShape2D").shape
	return shape.extents.x

func get_end():
	var size = get_size()
	return position.x + size / 2

func set_start(start: float):
	var size = get_size()
	position.x = start + size / 2
