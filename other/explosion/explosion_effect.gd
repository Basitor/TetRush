extends CPUParticles2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var explosion: Area2D = $Explosion
@onready var explosion_collision: CollisionShape2D = $Explosion/Collision

@export var explosion_force: float = 1000
@export var explosion_radius: float = 55.0

func _ready() -> void:
	explosion_collision.shape.radius = explosion_radius

func explode() -> void:
	var impulse_direction: Vector2

	emitting = true
	
	audio_stream_player_2d.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player_2d.play()
	
	for figure in explosion.get_overlapping_bodies():
		if figure is Figure and not figure.solid_buff:
			if figure.current_state == Figure.FIGURE_STATES.FALL:
				figure.set_idle()
			impulse_direction = (figure.global_position - global_position).normalized()
			figure.apply_impulse(impulse_direction * explosion_force, impulse_direction)

func _on_finished() -> void:
	queue_free()
