extends Position2D
class_name RigidRope

onready var state_machine: StateMachine = $StateMachine
onready var aim: RayCast2D = $Aim
onready var body := get_parent()

signal attached
signal detached

func _on_Swing_Hooked():
	emit_signal("attached")
	
func _on_Swing_Released():
	emit_signal("detached")

func get_mouse_position() -> Vector2:
	return get_global_mouse_position()

func _ready():
	state_machine.get_node("Swing").connect("hooked", self, "_on_Swing_Hooked")
	state_machine.get_node("Swing").connect("released", self, "_on_Swing_Released")


