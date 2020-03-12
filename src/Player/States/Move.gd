extends State
# Parent state that abstracts and handles basic movement
# Move-related children states can delegate movement to it, or use its utility functions

export var max_speed_default := Vector2(500.0, 1500.0)
export var acceleration_default := Vector2(100000.0, 3000.0)
export var jump_impulse := 1500.0

var acceleration := acceleration_default
var max_speed := max_speed_default
var velocity := Vector2.ZERO
var snap_distance := 32.0
var snap_vector := Vector2(0, 32)

func _on_Rope_attached() -> void:
	_state_machine.transition_to("Move/Hooked")
	
func _on_Rope_detached() -> void:
	if owner.is_on_floor():
		var target_state := "Move/Idle" if get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)
	else:
		_state_machine.transition_to("Move/Air")
		

func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("ui_up") and !owner.rope.is_attached():
		_state_machine.transition_to("Move/Air", { impulse = jump_impulse })
	
func physics_process(delta: float) -> void:
	update_direction()
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta, get_move_direction())
	velocity = owner.move_and_slide_with_snap(velocity, snap_vector, owner.FLOOR_NORMAL)
	
func enter(msg: Dictionary = {}) -> void:
	owner.rope.connect("attached", self, "_on_Rope_attached")
	owner.rope.connect("detached", self, "_on_Rope_detached")


func exit() -> void:
	owner.rope.disconnect("attached", self, "_on_Rope_attached")
	owner.rope.disconnect("detached", self, "_on_Rope_detached")

static func calculate_velocity(
		old_velocity: Vector2,
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2
	) -> Vector2:
	var new_velocity := old_velocity

	new_velocity.y += move_direction.y * acceleration.y * delta
	new_velocity.x = move_direction.x * acceleration.x * delta

	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)

	return new_velocity
	
static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		1.0
	)

func set_animation(name: String = "Idle") -> void:
	owner.animation.set_animation(name)

func update_direction() -> void:
	var direction = get_move_direction().x
	if direction != 0.0:
		owner.animation.set_flip_h(direction == -1.0) 
