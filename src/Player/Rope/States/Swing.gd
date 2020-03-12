tool
extends State

signal hooked
signal released

var RopeForce := preload("res://src/Player/Rope/RopeForce.tscn")
var force = null
var rope_points := []
var rope_length := 0.0

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("release_rope"):
		_state_machine.transition_to("Aim")
	if (owner.aim.is_colliding() and event.is_action_released("shoot_rope")):
		_state_machine.transition_to("Swing", { position = owner.aim.get_collision_point() })
	
func physics_process(delta: float) -> void:
	updateForcePosition()
	
func enter(msg: Dictionary = {}) -> void:
	if "position" in msg:
		emit_signal("hooked")
		force = RopeForce.instance()
		force.position = msg.position
		rope_points.append(msg.position)
		rope_length = get_rope_vector().length()
		
		get_tree().get_root().add_child(force)
		force.set_radius(rope_length)
	else:
		_state_machine.transition_to("Aim")
		
func exit() -> void:
	force.free()
	rope_points.clear()
	emit_signal("released")
	
func updateForcePosition() -> void:
	force.rotation = deg2rad(rad2deg(get_rope_vector().angle()) + 90)
	force.set_radius(rope_length)
	
func get_rope_vector(point_number: int = 0) -> Vector2:
	return get_swing_position(point_number) - owner.body.position
	
func get_swing_position(point_number: int = 0) -> Vector2:
	return rope_points[point_number]
	
