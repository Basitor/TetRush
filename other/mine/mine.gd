extends Area2D

class_name Mine

const EXPLOSION_EFFECT = preload("res://other/mine/ExplosionEffect.tscn")

@onready var explosion: Area2D = $Explosion
@export var explosion_force: float = 300


func _set_exlode(body: Node2D) -> void:
	if body == get_parent(): return
	explode()

func explode() -> void:
	var direction: Vector2
	var effect: CPUParticles2D
	var parent_figure: Figure = get_parent()

	# apply impulse to figures
	for other_figure in explosion.get_overlapping_bodies():
		if other_figure is Figure:
			direction = (other_figure.global_position - global_position).normalized()
			other_figure.apply_impulse(direction * explosion_force, direction)

	# apply impulse to parent
	if parent_figure.current_state == Figure.FIGURE_STATES.FALL:
		parent_figure.set_idle()
	direction = (parent_figure.global_position - global_position).normalized()
	get_parent().apply_impulse(direction * explosion_force, direction)
	
	# TODO detonate other mines (recursion)
	#for other_mine in explosion.get_overlapping_areas():
		#if other_mine is Mine and other_mine != self:
			#if not other_mine.is_queued_for_deletion():
				#other_mine.explode()
	effect = EXPLOSION_EFFECT.instantiate()
	effect.global_position = global_position
	get_parent().get_parent().add_child(effect)

	queue_free()
