extends State
# Parent state that abstracts and handles basic movement
# Move-related children states can delegate movement to it, or use its utility functions

export var max_speed_default := Vector2(500.0, 1500.0)
export var acceleration_default := Vector2(100000.0, 3000.0)
export var jump_impulse := Vector2(0.0, -800.0)

var acceleration := acceleration_default
var max_speed := max_speed_default
var force := Vector2.ZERO

func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("ui_up"):
		_state_machine.transition_to("Move/Air", { impulse = jump_impulse })

	
func physics_process(delta: float) -> void:
	if owner.rotation != 0.0:
		owner.rotation = 0.0
	
	var old_velocity = owner.get_linear_velocity()
	var new_velocity = calculate_velocity(old_velocity, max_speed, acceleration, delta, get_move_direction())
	owner.set_linear_velocity(new_velocity + force)
	force = Vector2.ZERO
	
func enter(msg: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity := old_velocity

	new_velocity.x = move_direction.x * acceleration.x * delta

	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)

	return new_velocity
	
static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		1.0
	)
