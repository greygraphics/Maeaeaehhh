extends Node2D


func get_size():
	var shape = get_node("Body/Ground").shape
	return shape.extents.x

func get_end():
	var size = get_size()
	var end = position.x + size
	return end

func set_start(start: float):
	var size = get_size()
	position.x = start + size
