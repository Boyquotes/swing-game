tool
extends State

signal jumped

export var acceleration_x := 180000.0

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_up") and !is_falling():
		_parent.velocity.y = 0.0
	_parent.unhandled_input(event)
	
func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	
	if is_falling():
		_parent.set_animation("Fall")
	
	# Landing
	if owner.is_on_floor():
		var target_state := "Move/Idle" if _parent.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)
		
func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	
	_parent.acceleration.x = acceleration_x
	_parent.snap_vector.y = 0
	
	if "velocity" in msg:
		_parent.velocity = msg.velocity
		_parent.max_speed.x = max(abs(msg.velocity.x), _parent.max_speed.x)
	if "impulse" in msg:
		_parent.velocity += calculate_jump_velocity(msg.impulse)
		_parent.set_animation("Jump")
	
func exit() -> void:
	_parent.acceleration = _parent.acceleration_default
	_parent.snap_vector.y = _parent.snap_distance
	_parent.exit()
	
func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return _parent.calculate_velocity(
		_parent.velocity,
		_parent.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)

func is_falling() -> bool:
	return (_parent.velocity.y > 0.0)
