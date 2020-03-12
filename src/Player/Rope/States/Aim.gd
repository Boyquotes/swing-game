tool
extends State

func unhandled_input(event: InputEvent) -> void:
	if (owner.aim.is_colliding() and event.is_action_released("shoot_rope")):
		_state_machine.transition_to("Swing", { position = owner.aim.get_collision_point() })
	
func physics_process(delta: float) -> void:
	pass

	
func enter(msg: Dictionary = {}) -> void:
	pass
	
func exit() -> void:
	pass
	

