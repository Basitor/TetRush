extends Node2D

const LEVEL = preload("res://level/Level.tscn")

@onready var settings: Settings = $CanvasLayer/Settings
@onready var menu: Control = $CanvasLayer/Menu
@onready var old_effect: ColorRect = $CanvasLayer/OldEffect

var level: Level

func _ready() -> void:
	GlobalEvents.show_main_menu.connect(func(on: bool): menu.visible = on)
	GlobalEvents.end_game.connect(func():
		GlobalEvents.game_on = false
		if level: level.queue_free()
	)
	GlobalEvents.change_old_tv.connect(func(on: bool): old_effect.visible = on)
	GlobalEvents.restart_level.connect(_generate_level)

func _on_settings_pressed() -> void:
	GlobalEvents.show_settings.emit(true)
	GlobalEvents.show_main_menu.emit(false)
	
func _generate_level() -> void:
	get_tree().paused = false
	GlobalEvents.show_main_menu.emit(false)
	GlobalEvents.show_settings.emit(false)
	GlobalEvents.game_on = true
	level = LEVEL.instantiate()
	add_child(level)

func _on_start_normal_pressed() -> void:
	GlobalEvents.zen_mode = false
	_generate_level()

func _on_start_zen_pressed() -> void:
	GlobalEvents.zen_mode = true
	_generate_level()
