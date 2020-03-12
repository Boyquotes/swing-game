extends StaticBody2D
class_name RopeForce

onready var collision: CollisionShape2D = get_node("Collision")
onready var shape: LineShape2D = collision.get_shape()

func set_radius(radius: float) -> void:
	shape.set_d(-radius - 10)
	
func _ready() -> void:
	add_to_group("rope_force")
