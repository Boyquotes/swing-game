tool
extends State

func unhandled_input(event: InputEvent) -> void:
	if (owner.aim.is_colliding() and event.is_action_released("shoot_rope")):
		_state_machine.transition_to("Swing", { position = owner.aim.get_collision_point() })
	
func physics_process(delta: float) -> void:
	updateAim()

	
func enter(msg: Dictionary = {}) -> void:
	owner.aim.set_enabled(true)
	
func exit() -> void:
	owner.aim.set_enabled(false)
	
func updateAim() -> void:
	var mousePosition = owner.get_mouse_position()
	var angle = (mousePosition - owner.body.position).angle()
	owner.aim.rotation = angle
	
