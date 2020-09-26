extends RigidBody2D


export var distance := 50.0


func _physics_process(delta: float) -> void:
	var stretch := Input.get_action_strength("ui_up")
	$CollisionShape2D.position = Vector2.DOWN * stretch * distance
