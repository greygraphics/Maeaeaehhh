extends Node2D

export var input: String = "tongue"
export var tongue_max_length = 250
export var tongue_time = 0.3

var tongue_length = 0
var extended = false

onready var initial_tongue_scale = $Sprite.scale.x
onready var initial_tongue_start = $Sprite.position.y

func _process(delta):
	if extended:
		tongue_length = clamp(tongue_max_length / tongue_time * delta + tongue_length, 0, tongue_max_length)
	if not extended:
		tongue_length = clamp(-tongue_max_length / tongue_time * delta + tongue_length, 0, tongue_max_length)
	updateSprite()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(input):
		extended = true
	if Input.is_action_just_released(input):
		extended = false

func updateSprite():
	$Sprite.scale.x = tongue_length / tongue_max_length * initial_tongue_scale
	$Sprite.position.y = initial_tongue_start + tongue_length / 2
