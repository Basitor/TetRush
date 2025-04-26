extends Node

# menu signals
signal show_main_menu(on: bool)
signal show_settings(on: bool)
signal restart_level
signal end_game

# gameplay signals
signal figure_done(figure: Figure)
signal new_figure
signal camera_shake
signal take_damage

# global settings
signal change_music(value: bool)
signal change_effects(value: bool)
signal change_old_tv(value: bool)

# global vars
var zen_mode: bool = false
var music: bool = true: set = _change_music
var effects: bool = true: set = _change_effects
var old_tv: bool = true: set = _change_old_tv

var game_on: bool = false


func _change_music(value: bool) -> void:
	music = value
	change_music.emit(value)

func _change_effects(value: bool) -> void:
	effects = value
	change_effects.emit(value)

func _change_old_tv(value: bool) -> void:
	old_tv = value
	change_old_tv.emit(value)
