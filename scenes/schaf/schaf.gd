extends Node2D


export var distance := 50.0

onready var body = $Body
onready	var legRoot = $Body/LegRoot
onready var leg := $Body/LegRoot/Leg


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		var collision = leg.move_and_collide(legRoot.transform.basis_xform(Vector2.RIGHT) * distance)
		#if collision.collider.is_in_group("bodies"):
		if collision:
			body.apply_central_impulse(collision.normal * 1000)
	if Input.is_action_just_released("ui_up"):
		var collision = leg.move_and_collide(- legRoot.transform.basis_xform(Vector2.RIGHT) * distance)
