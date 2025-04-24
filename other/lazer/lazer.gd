class_name Lazer extends Area2D

const MARK_TARGET = preload("res://resources/images/target.png")

@onready var lazer_line: Line2D = $LazerLine
@onready var scan_collision: CollisionPolygon2D = $ScanCollision
@onready var lazer_gun: Sprite2D = $LazerGun

@export var scan_rotation_speed: float = 50.0
@export var lazer_speed: float = 1500.0

var comets: Array
var current_comet: Comet
var current_point: Vector2 = Vector2.ZERO


func enable_scan() -> void:
	scan_collision.show()
	scan_collision.disabled = false
	scan_rotation_speed = randf_range(scan_rotation_speed * 0.8, scan_rotation_speed * 1.1)

func _physics_process(delta: float) -> void:
	var line_points: PackedVector2Array

	scan_collision.rotation += scan_rotation_speed * delta
	
	line_points = PackedVector2Array([Vector2.ZERO, ])
	lazer_line.points = line_points

	if current_comet and not current_comet.is_queued_for_deletion():
		current_point = current_point.move_toward(to_local(current_comet.global_position), lazer_speed * delta)
		line_points = PackedVector2Array([Vector2.ZERO, current_point])
		lazer_gun.look_at(current_comet.global_position)
		
		if abs((current_point - to_local(current_comet.global_position)).length()) < 10.0:
			current_comet.explode()
			current_point = Vector2.ZERO
		lazer_line.points = line_points
		return

	if comets:
		current_comet = comets.pop_front()

func _on_body_entered(comet: Comet) -> void:
	var mark_comet: Sprite2D

	if comet is Comet and not comet.is_queued_for_deletion() and comet not in comets:
		comets.append(comet)
		mark_comet = Sprite2D.new()
		mark_comet.texture = MARK_TARGET
		mark_comet.scale = Vector2(2, 2)
		mark_comet.modulate = Color.RED
		comet.call_deferred("add_child", mark_comet)
