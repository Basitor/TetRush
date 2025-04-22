extends Marker2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var blink_red_color: ColorRect = $CanvasLayer/BlinkRedColor
@onready var move_area: Area2D = $MoveArea
@onready var collision_shape_2d: CollisionShape2D = $MoveArea/CollisionShape2D


const L = preload("res://figures/shapes/L.tscn")
const LINE = preload("res://figures/shapes/Line.tscn")
const L_SMALL = preload("res://figures/shapes/L_small.tscn")
const SQUARE = preload("res://figures/shapes/Square.tscn")
const Z = preload("res://figures/shapes/Z.tscn")
const J = preload("res://figures/shapes/J.tscn")
const T = preload("res://figures/shapes/T.tscn")

const FIGURES = [L, LINE, L_SMALL, SQUARE, Z, J, T]

@export var up_distance: float = 75.0
@export var camera_speed: float = 300.0
@export var camera_shake_intencity: float = 3.0
@export var camera_shake_time: float = 0.2
@export var blink_red_intencity: float = 0.5
@export var blink_red_time: float = 0.2

var active_figure: Figure
var moving_figure: Figure
var desired_y: float
var camera_shake_noise: FastNoiseLite


func _ready() -> void:
	call_deferred("_gen_figure")
	call_deferred("_let_figure")
	desired_y = global_position.y
	GlobalEvents.figure_done.connect(_figure_done)
	GlobalEvents.camera_shake.connect(_on_camera_shake)
	GlobalEvents.take_damage.connect(_on_take_damage)
	camera_shake_noise = FastNoiseLite.new()

func _process(delta: float) -> void:
	if global_position.y != desired_y:
		global_position.y = move_toward(global_position.y, desired_y, camera_speed * delta)

func _gen_figure() -> void:
	var figure = FIGURES.pick_random()
	active_figure = figure.instantiate()
	add_child(active_figure)
	active_figure.global_position = global_position + Vector2(active_figure.position_offset, 0)

func _let_figure() -> void:
	active_figure.current_state = active_figure.FIGURE_STATES.FALL
	active_figure.reparent(get_parent())
	call_deferred("_gen_figure")
	GlobalEvents.new_figure.emit()
	moving_figure = active_figure

func shake_camera(intensity: float) -> void:
	var camera_offset = camera_shake_noise.get_noise_1d(Time.get_ticks_msec()) * intensity
	camera_2d.offset = Vector2(camera_offset, camera_offset)

func _on_camera_shake() -> void:
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(shake_camera, camera_shake_intencity, 1.0, camera_shake_time)

func _figure_done(figure: Figure) -> void:
	if figure.global_position.y <= global_position.y + collision_shape_2d.shape.get_rect().size.y:
		move_camera_up()
	if figure == moving_figure:
		call_deferred("_let_figure")

func move_camera_up() -> void:
	desired_y -= up_distance

func _on_area_2d_body_entered(_body: Node2D) -> void:
	move_camera_up()

func _on_take_damage() -> void:
	var blink_tween = get_tree().create_tween()
	blink_tween.tween_method(blink_red, blink_red_intencity, 0, blink_red_time)

func blink_red(intensity: float) -> void:
	blink_red_color.color.a = intensity
