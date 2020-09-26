extends Node2D

export var factor: float = 0.5
export var static_pos: float = 0

func _process(delta):
	var cam = get_parent().get_node("Schaf") # historisch gewachsen
	var cam_pos = cam.position.x
	position.x = cam_pos * 0.5 + static_pos
