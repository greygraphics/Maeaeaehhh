extends AudioStreamPlayer2D


func _destroy():
	queue_free()
