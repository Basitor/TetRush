extends Area2D

class_name Mine

@export var explosion_force: float = 1200.0
@export var explosion_radius: float = 55.0

const EXPLOSION_EFFECT = preload("res://other/explosion/ExplosionEffect.tscn")

var effect: CPUParticles2D

func _set_explode(body: Node2D) -> void:
	if body == get_parent(): return
	effect = EXPLOSION_EFFECT.instantiate()
	effect.explosion_radius = explosion_radius
	effect.explosion_force = explosion_force
	effect.global_position = global_position
	get_parent().get_parent().call_deferred("add_child", effect)
	queue_free()
