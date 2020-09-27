extends Node2D


export var sound_effect_list : Resource


var SoundEffect := preload("res://scenes/sheep/sound_effect.tscn")


func _ready() -> void:
	assert(sound_effect_list.sounds.size() > 0, "Too few hit sounds")


func play_effect() -> void:
	var sound := _pick_random(sound_effect_list.sounds) as AudioStream
	var new_player := SoundEffect.instance()
	new_player.stream = sound
	add_child(new_player)


func _pick_random(arr: Array):
	return arr[randi() % arr.size()]
