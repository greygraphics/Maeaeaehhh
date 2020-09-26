extends Node2D


func _ready():
	add_chunk()
	add_chunk()

func _process(delta):
	pass

func add_chunk():
	var end = get_end()
	
	var chunk = preload("res://scenes/chunk.tscn").instance()
	chunk.set_start(end)
	add_child(chunk)

func get_end():
	var existing = get_tree().get_nodes_in_group("chunk")
	
	if existing.size() == 0:
		return 0
	
	var end = existing[0].get_end()
	for node in existing:
		var node_end = node.get_end()
		
		if end < node_end:
			end = node_end
	
	return end
