extends KinematicBody2D
class_name Player

onready var state_machine: StateMachine = $StateMachine

onready var collider: CollisionShape2D = $CollisionShape2D setget ,get_collider
onready var rope: Rope = $Rope
onready var animation: AnimatedSprite = $AnimatedSprite

const FLOOR_NORMAL := Vector2.UP

func get_collider() -> CollisionShape2D:
	return collider
