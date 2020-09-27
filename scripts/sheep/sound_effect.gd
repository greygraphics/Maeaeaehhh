extends AudioStreamPlayer2D


export var sound_effect_list : Resource


func _ready() -> void:
	assert(sound_effect_list.sounds.size() > 0, "Too few hit sounds")


func play_effect() -> void:
	if playing:
		return
	var sound := _pick_random(sound_effect_list.sounds) as AudioStream
	stream = sound
	play()


func _pick_random(arr: Array):
	return arr[randi() % arr.size()]
