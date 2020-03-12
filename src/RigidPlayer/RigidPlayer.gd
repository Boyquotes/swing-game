extends RigidBody2D
class_name RigidPlayer

onready var state_machine: StateMachine = $StateMachine

onready var collider: CollisionShape2D = $CollisionShape2D setget ,get_collider
onready var ground_check: Area2D = $GroundCheck
onready var rope: Rope = $Rope

func _ready() -> void:
	rope.connect("attached", self, "_on_Rope_Attached")
	rope.connect("detached", self, "_on_Rope_Detached")
	
func _on_Rope_Attached() -> void:
	state_machine.transition_to("Move/Hooked")
	
func _on_Rope_Detached() -> void:
	state_machine.transition_to("Move/Air")

func get_collider() -> CollisionShape2D:
	return collider

func is_on_floor() -> bool:
	return ground_check.get_overlapping_bodies().size() > 0
