extends Node2D


var end_offset = 100
var chunk_types = [
	preload("res://scenes/chunks/empty.tscn"),
	preload("res://scenes/chunks/hole.tscn")
]

func _ready():
	add_chunk()
	add_chunk()

func _process(delta):
	var end = get_end()
	
	if $Camera.get_end() + end_offset > end:
		add_chunk()
	
	remove_left_chunks()

func add_chunk():
	var end = get_end()
	
	var chunk = get_random_chunk_type().instance()
	chunk.set_start(end)
	add_child(chunk)
	
func remove_left_chunks():
	# TODO
	pass

func get_end():
	var existing = get_chunks()
	if existing.size() == 0:
		return 0
	
	var end = existing[0].get_end()
	for node in existing:
		var node_end = node.get_end()
		
		if end < node_end:
			end = node_end
	
	return end

func get_chunks():
	return get_tree().get_nodes_in_group("chunk")
	
func get_random_chunk_type():
	var i = randi() % chunk_types.size()
	return chunk_types[i]
