extends Area2D

const EXPLOSION_EFFECT = preload("res://other/mine/ExplosionEffect.tscn")

@onready var explosion: Area2D = $Explosion
@export var explosion_force: float = 300
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_body_entered(body: Node2D) -> void:
	if body != get_parent():
		for figures in explosion.get_overlapping_bodies():
			if figures is Figure:
				var direction = (figures.global_position - global_position).normalized()
				figures.apply_impulse(direction * explosion_force, direction)

		audio_stream_player.play()
		var effect = EXPLOSION_EFFECT.instantiate()
		effect.global_position = global_position
		get_parent().get_parent().add_child(effect)

func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
