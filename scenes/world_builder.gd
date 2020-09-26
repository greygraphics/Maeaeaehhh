extends Node2D


var end_offset = 100
var chunk_types = [
	preload("res://scenes/chunks/empty.tscn"),
	preload("res://scenes/chunks/hole.tscn")
]
var back_types = [
	preload("res://scenes/back/trees.tscn")
]
var next_back = 0

func _ready():
	add_chunk()
	add_chunk()

func _process(delta):
	var end = get_end()
	
	if $Camera.get_end() + end_offset > end:
		add_chunk()
	
	if $Camera.get_end() + end_offset > next_back:
		add_back()
	
	remove_left_chunks()
	
func add_back():
	var back = get_random_back().instance()
	var width = back.get_node("Sprite").texture.get_size().x
	back.static_pos = next_back + width
	add_child(back)
	next_back = randi() % 500 + width + 100 + $Camera.get_end()

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
	
func get_random_back():
	var i = randi() % back_types.size()
	return back_types[i]
