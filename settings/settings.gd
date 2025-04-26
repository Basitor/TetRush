class_name Settings extends Control

@onready var music_toggle: CheckButton = $CanvasLayer/VBoxContainer/HSplitContainer/Container/Music
@onready var effects_toggle: CheckButton = $CanvasLayer/VBoxContainer/HSplitContainer/Container/Effects
@onready var old_tv_toggle: CheckButton = $CanvasLayer/VBoxContainer/HSplitContainer/Container/OldTV
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var restart: Button = $CanvasLayer/VBoxContainer/Restart
@onready var main_menu: Button = $CanvasLayer/VBoxContainer/MainMenu


func _ready() -> void:
	GlobalEvents.show_settings.connect(show_settings)
	music_toggle.button_pressed = GlobalEvents.music
	effects_toggle.button_pressed = GlobalEvents.effects
	old_tv_toggle.button_pressed = GlobalEvents.old_tv

func show_settings(on: bool) -> void:
	restart.visible = GlobalEvents.game_on
	main_menu.visible = GlobalEvents.game_on
	canvas_layer.visible = on

func _on_music_toggled(toggled_on: bool) -> void:
	GlobalEvents.music = toggled_on

func _on_effects_toggled(toggled_on: bool) -> void:
	GlobalEvents.effects = toggled_on

func _on_old_tv_toggled(toggled_on: bool) -> void:
	GlobalEvents.old_tv = toggled_on

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	GlobalEvents.end_game.emit()
	GlobalEvents.show_settings.emit(false)
	GlobalEvents.show_main_menu.emit(true)

func _on_back_button_pressed() -> void:
	get_tree().paused = false
	GlobalEvents.show_settings.emit(false)
	if not GlobalEvents.game_on:
		GlobalEvents.show_main_menu.emit(true)

func _on_restart_pressed() -> void:
	GlobalEvents.restart_level.emit()
