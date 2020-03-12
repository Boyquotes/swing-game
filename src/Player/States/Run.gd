tool
extends State

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	
func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if _parent.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	_parent.physics_process(delta)
		
func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	_parent.max_speed = _parent.max_speed_default
	_parent.velocity = Vector2.ZERO
	_parent.snap_vector.y = _parent.snap_distance
	
	_parent.set_animation("Run")
	
func exit() -> void:
	_parent.exit()
