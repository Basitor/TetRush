class_name Comet extends RigidBody2D

const EXPLOSION_EFFECT = preload("res://other/explosion/ExplosionEffect.tscn")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var explosion_force: float = 1000
@export var comet_speed: float = 200
@export var explosion_radius: float = 25.0

var is_ready = false
var effect: CPUParticles2D

func _physics_process(_delta: float) -> void:
	if linear_velocity.length() > 0.1:
		rotation = linear_velocity.angle()

func explode() -> void:
	effect = EXPLOSION_EFFECT.instantiate()
	effect.explosion_radius = explosion_radius
	effect.explosion_force = explosion_force
	effect.global_position = global_position
	get_parent().call_deferred("add_child", effect)
	queue_free()

func _set_exlode(_body: Node2D) -> void:
	explode()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
