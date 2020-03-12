extends Position2D

class_name Rope

onready var state_machine: StateMachine = $StateMachine
onready var aim: RayCast2D = $Aim
onready var body := get_parent()

signal attached
signal detached

var rope_attached: = false
var rope_length: = 0.0
var rope_points: = []
var rope_casts: = []
var current_point_index = -1
var rope_force = Vector2.ZERO
var staticbody = StaticBody2D.new()
var collision = CollisionShape2D.new()
var shape = LineShape2D.new()

func _on_Swing_Hooked():
	rope_attached = true
	emit_signal("attached")
	
func _on_Swing_Released():
	rope_attached = false
	emit_signal("detached")

func get_mouse_position() -> Vector2:
	return get_global_mouse_position()

func _ready():
	state_machine.get_node("Swing").connect("hooked", self, "_on_Swing_Hooked")
	state_machine.get_node("Swing").connect("released", self, "_on_Swing_Released")
	
func _physics_process(delta):
	updateAim()
	
func updateAim() -> void:
	var mousePosition = get_mouse_position()
	var angle = (mousePosition - body.position).angle()
	aim.rotation = angle
	
func is_attached() -> bool:
	return rope_attached

#func _draw():
#	if (is_attached()):
#		draw_line(Vector2(0,0), get_rope_vector(), Color.black, 5)
#		for i in range(rope_points.size() -1):
#			var one = Vector2(rope_points[i].x - body.position.x, rope_points[i].y - body.position.y)
#			var two = Vector2(rope_points[i+1].x - body.position.x, rope_points[i+1].y - body.position.y)
#			draw_line(one, two, Color.black, 5)
#
#
#
#func shoot_rope():
#	add_point(aim)
#	rope_length = get_rope_vector().length()
#	rope_attached = true
#	staticbody.position = get_position()
#	shape.set_d(get_swing_radius())
#	collision.set_shape(shape)
#
#func release_rope():
#	rope_points.clear()
#	rope_attached = false
#	current_point_index = -1
#	remove_rope_casts()
#
#func remove_rope_casts() -> void:
#	for cast in rope_casts:
#		cast.free()
#	rope_casts.clear()
#

#
#func get_position() -> Vector2:
#	return rope_points[current_point_index] if rope_points.size() > 0 else Vector2.ZERO
#
#func get_rope_vector() -> Vector2:
#	return Vector2(get_position().x - body.position.x, get_position().y - body.position.y)
#
#func get_point_vector(i: int) -> Vector2:
#	return Vector2(rope_points[i].x - body.position.x, rope_points[i].y - body.position.y)
#
#func is_under_point() -> bool:
#	return get_rope_vector().angle() < 0
#
#func update_swing() -> void:
#	staticbody.rotation = deg2rad(rad2deg(get_rope_vector().angle()) + 90)
#	staticbody.position = get_position()
#	staticbody.set_collision_layer_bit(0, false)
#	staticbody.set_collision_layer_bit(3, true)
#	staticbody.set_collision_mask_bit(0, false)
#	staticbody.set_collision_mask_bit(3, true)
#	collision.set_disabled(!is_attached())
#
#	shape.set_d(get_swing_radius())
#	if !body.get_parent().has_node(staticbody.get_path()):
#		body.get_parent().add_child(staticbody)
#		staticbody.add_child(collision)
#
#func update_points() -> void:
#	var not_found = true
#	for i in range(rope_points.size()):
#		if not_found:
#			rope_casts[i].set_cast_to(rope_cast_vector(i))
#			rope_casts[i].force_raycast_update()
#			if use_rope_point(i):
#				current_point_index = i
#				not_found = false
#
#	var size = rope_points.size()
#	for i in range(size - 1, current_point_index, -1):
#		rope_points.remove(i)
#		rope_casts[i].free()
#		rope_casts.remove(i)
#
#	if not_found:
#		add_point(rope_casts.back())
#
#func use_rope_point(i: int):
#	var difference_point = rope_casts[i].get_collision_point() - rope_points[i]
#	return difference_point.length() < 0.2
#
#func rope_cast_vector(i: int) -> Vector2:
#	var rope = get_point_vector(i)
#	var rope_length = rope.length() * 2
#	return Vector2(rope_length * cos(rope.angle()), rope_length * sin(rope.angle()))
#
#func add_point(raycast: RayCast2D) -> void:
#	rope_points.append(raycast.get_collision_point())
#	current_point_index += 1
#
#	var cast = RayCast2D.new()
#	cast.set_collision_mask_bit(0, false)
#	cast.set_collision_mask_bit(1, true)
#	cast.set_enabled(true)
#	cast.set_cast_to(get_rope_vector())
#	rope_casts.append(cast)
#	add_child(cast)
#
#
#func get_swing_radius() -> float:
#	var new_length = rope_length
#	var c = 0
#	var i = 1
#	while i <= current_point_index:
#		c += rope_points[i-1].distance_to(rope_points[i])
#		i += 1
#	return -(new_length + 20 - c)
