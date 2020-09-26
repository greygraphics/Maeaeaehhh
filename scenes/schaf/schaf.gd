extends Node2D


export var distance := 50.0


onready var leg := $Leg
onready var legpos := $LegPos
onready var joint := $GrooveJoint2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var stretch := Input.get_action_strength("ui_up")
	var direction := legpos.position.normalized() as Vector2
#	joint.rest_length = stretch * distance
