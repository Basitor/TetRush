class_name Mine extends Area2D

@export var explosion_force: float = 1400.0
@export var explosion_radius: float = 55.0

const EXPLOSION_EFFECT = preload("res://other/explosion/ExplosionEffect.tscn")
@onready var color_rect: ColorRect = $ColorRect

var effect: CPUParticles2D
var current_time: float = 0

func _process(delta: float) -> void:
	current_time += delta
	color_rect.material.set_shader_parameter("time", current_time) 

func explode() -> void:
	effect = EXPLOSION_EFFECT.instantiate()
	effect.explosion_radius = explosion_radius
	effect.explosion_force = explosion_force
	effect.global_position = global_position
	get_parent().get_parent().call_deferred("add_child", effect)
	queue_free()

func _set_explode(body: Node2D) -> void:
	if body == get_parent(): return
	explode()
