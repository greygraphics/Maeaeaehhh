extends RigidBody2D

export var distance := 50.0


func _ready() -> void:
	pass # Replace with function body.


func _integrate_forces(state):
	for index in state.get_contact_count():
		print(state.get_contact_collider_shape(index))
		


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		add_torque(10000)
		
