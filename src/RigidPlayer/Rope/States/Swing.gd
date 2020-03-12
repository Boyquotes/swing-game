tool
extends State

signal hooked
signal released

var Hinge := preload("res://src/RigidPlayer/Rope/Hinge.tscn")
var hinge = null
var hinge_points = []

func unhandled_input(event: InputEvent) -> void:
	if (event.is_action_released("release_rope")):
		_state_machine.transition_to("Aim")
	
func physics_process(delta: float) -> void:
	pass
	
func enter(msg: Dictionary = {}) -> void:
	if "position" in msg:
		emit_signal("hooked")
		hinge = Hinge.instance()
		hinge.get_node("Collision/Pin").set_node_b(owner.body.get_path())
		hinge.position = msg.position
		hinge_points.append(msg.position)
		get_tree().get_root().add_child(hinge)
	else:
		_state_machine.transition_to("Aim")
		
func exit() -> void:
	hinge.free()
	hinge_points.clear()
	emit_signal("released")
	
