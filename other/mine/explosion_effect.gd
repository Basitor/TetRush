extends CPUParticles2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	emitting = true
	audio_stream_player_2d.play()
	
func _on_finished() -> void:
	queue_free()
