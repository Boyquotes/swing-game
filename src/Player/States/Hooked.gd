tool
extends State

export var max_speed_default := Vector2(500.0, 1500.0)
export var acceleration_default := Vector2(10000.0, 3000.0)
export var jump_impulse := 1500.0

var acceleration := acceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO

func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	
func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, _parent.get_move_direction())
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
		
func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)
	velocity = _parent.velocity
	
func exit() -> void:
	_parent.exit()
	_parent.velocity = velocity
	
static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity := old_velocity

	new_velocity.y += move_direction.y * acceleration.y * delta
	new_velocity.x += move_direction.x * acceleration.x * delta * 0.05

	return new_velocity
	
