tool
extends State

var acceleration := Vector2(40000.0, 3000.0)

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_up") and owner.get_linear_velocity().y < 0.0:
		owner.set_linear_velocity(Vector2.ZERO)
	_parent.unhandled_input(event)
	
func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	
	# Landing
	if owner.is_on_floor():
		var target_state := "Move/Idle" if _parent.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)
	
func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	_parent.acceleration = acceleration
	
	if "impulse" in msg:
		_parent.force = msg.impulse
		
	
func exit() -> void:
	_parent.exit()
	
	_parent.acceleration = _parent.acceleration_default

func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return _parent.calculate_velocity(
		_parent.velocity,
		_parent.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)
