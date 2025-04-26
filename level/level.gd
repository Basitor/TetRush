class_name Level extends Node2D

@export var MAX_HEALTH: int = 3
@export var blink_red_intencity: float = 0.5
@export var blink_red_time: float = 0.2

@onready var spawner: Marker2D = $Spawner
@onready var collision_polygon_2d: CollisionPolygon2D = $MainBase/CollisionPolygon2D
@onready var game_over: CanvasLayer = $GameOver
@onready var falling_stars: CPUParticles2D = $ParallaxBackground/FallingStars
@onready var blink_red_color: ColorRect = $ParallaxBackground/BlinkRedColor

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# LABELS
@onready var figure_num_label: Label = $ParallaxBackground/FiguresNum/HBoxContainer/NumLabel
@onready var health_num_label: Label = $ParallaxBackground/FiguresNum/Health/NumLabel
@onready var score_num: Label = $GameOver/VBoxContainer/HBoxContainer/ScoreNum

@onready var health_num: int = MAX_HEALTH
var figures_num: int = 0

func _ready() -> void:
	if GlobalEvents.zen_mode:
		health_num_label.text = "Infinite"
	else:
		health_num_label.text = str(MAX_HEALTH)
	GlobalEvents.new_figure.connect(_on_spawner_new_figure)
	GlobalEvents.take_damage.connect(take_damage)
	audio_stream_player.playing = GlobalEvents.music
	GlobalEvents.change_music.connect(_toggle_music)
	GlobalEvents.show_main_menu.connect(func(_on: bool): queue_free())

func take_damage() -> void:
	if GlobalEvents.zen_mode: return
	health_num = int(health_num_label.text) - 1
	health_num_label.text = str(health_num)
	
	var blink_tween = get_tree().create_tween()
	blink_tween.tween_method(blink_red, blink_red_intencity, 0, blink_red_time)
	
	if health_num <= 0:
		score_num.text = str(figures_num)
		get_tree().paused = true
		game_over.show()

func _input(event):
	if event.is_action_just_pressed("esc_back"):
		_on_button_pressed()

func _on_spawner_new_figure() -> void:
	figures_num += 1
	figure_num_label.text = str(figures_num)

func _toggle_music(on: bool) -> void:
	audio_stream_player.playing = on

func _on_button_pressed() -> void:
	get_tree().paused = true
	GlobalEvents.show_settings.emit(true)

func _on_restart_button_pressed() -> void:
	GlobalEvents.restart_level.emit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	GlobalEvents.end_game.emit()
	GlobalEvents.show_settings.emit(false)
	GlobalEvents.show_main_menu.emit(true)

func blink_red(intensity: float) -> void:
	blink_red_color.color.a = intensity

func _on_figure_felt_area_entered(area: Area2D) -> void:
	GlobalEvents.figure_done.emit(area.get_parent())
	GlobalEvents.take_damage.emit()
	area.get_parent().remove_timer.start()
