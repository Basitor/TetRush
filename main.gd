extends Node2D

@export var MAX_HEALTH: int = 3

@onready var spawner: Marker2D = $Spawner
@onready var collision_polygon_2d: CollisionPolygon2D = $MainBase/CollisionPolygon2D
@onready var figure_num_label: Label = $ParallaxBackground/FiguresNum/HBoxContainer/NumLabel
@onready var health_num_label: Label = $ParallaxBackground/FiguresNum/Health/NumLabel
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var mute_button: Button = $ParallaxBackground/VBoxContainer/MuteButton
@onready var game_over: CanvasLayer = $GameOver
@onready var score_num: Label = $GameOver/VBoxContainer/HBoxContainer/ScoreNum
@onready var background_stars_button: Button = $ParallaxBackground/VBoxContainer/BackgroundStars
@onready var falling_stars: CPUParticles2D = $ParallaxBackground/FallingStars

@onready var health_num: int = MAX_HEALTH
var figures_num: int = 0

func _ready() -> void:
	health_num_label.text = str(MAX_HEALTH)
	GlobalEvents.new_figure.connect(_on_spawner_new_figure)
	GlobalEvents.take_damage.connect(take_damage)

func take_damage() -> void:
	health_num = int(health_num_label.text) - 1
	health_num_label.text = str(health_num)
	if health_num <= 0:
		score_num.text = str(figures_num)
		get_tree().paused = true
		game_over.show()

func _on_spawner_new_figure() -> void:
	figures_num += 1
	figure_num_label.text = str(figures_num)

func _restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _mute_button_pressed() -> void:
	if background_music.playing:
		mute_button.text = "Music: Off"
		background_music.stop()
	else:
		mute_button.text = "Music: On"
		background_music.play()

func _on_background_stars_pressed() -> void:
	if falling_stars.emitting:
		background_stars_button.text = "Stars: Off"
		falling_stars.emitting = false
	else:
		background_stars_button.text = "Stars: On"
		falling_stars.emitting = true
