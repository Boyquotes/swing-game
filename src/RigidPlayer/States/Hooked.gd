tool
extends State

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	
func physics_process(delta: float) -> void:
	var force = Vector2(_parent.get_move_direction().x * 10.0, 0.0)
	owner.apply_central_impulse(force)
	
func enter(msg: Dictionary = {}) -> void:
	owner.set_mode(RigidBody2D.MODE_RIGID)
	_parent.enter(msg)
	
	
func exit() -> void:
	owner.set_mode(RigidBody2D.MODE_CHARACTER)
	_parent.exit()
	
