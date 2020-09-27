extends Node2D


func get_end():
	return $Body/End.global_position.x

func set_start(start: float):
	global_position.x = start
