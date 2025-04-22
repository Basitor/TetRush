extends RigidBody2D

class_name Figure

const FIGURE_SET_SOUND = preload("res://resources/sound/figure_set.wav")
const FIGURE_MOVE_SOUND = preload("res://resources/sound/figure_move.wav")
const MINE = preload("res://other/mine/Mine.tscn")

@onready var sprite: Sprite2D = $Sprite
@onready var solid_sprite: Sprite2D = $SolidSprite
@onready var solid_animation_player: AnimationPlayer = $SolidSprite/AnimationPlayer
@onready var sound_player: AudioStreamPlayer2D = $SoundPlayer
@onready var line_2d: Line2D = $Line2D
@onready var collision: CollisionPolygon2D = $Collision
@onready var collision_small: CollisionPolygon2D = $CollisionSmall
@onready var mine_points: Node2D = $MinePoints
@onready var overlap_area: Area2D = $OverlapArea
@onready var overlap_collision_polygon: CollisionPolygon2D = $OverlapArea/CollisionPolygon2D
# timers
@onready var idle_timer: Timer = $IdleTimer
@onready var remove_timer: Timer = $RemoveTimer

@export var side_step: float = 10.0
@export var side_move_speed: float = 700.0
@export var fall_speed: float = 50.0
@export var fast_fall_multiplier: int = 3
@export var rotate_speed: float = 30.0
@export var move_cooldown: float = 0.08
@export var position_offset: float = 0.0
@export var solid_buff: bool = false

enum FIGURE_STATES { HANG, FALL, IDLE, SOLID }
enum BUFFS { MINE, SOLID }

var current_state: FIGURE_STATES = FIGURE_STATES.HANG: set = _set_state
var target_rotation: float
var target_x: float
var rotating: bool = false
var moving_to_side: bool = false
var move_timer: float = 0


func _ready() -> void:
	target_rotation = rotation
	target_x = position.x
	modulate = Color.from_hsv(randf(), randf_range(0.2, 0.4), randf_range(0.85, 1.0), 0.2)
	line_2d.points = collision_small.polygon
	overlap_collision_polygon.polygon = collision.polygon
	
	choose_buff()
	
	if solid_buff:
		solid_sprite.region_enabled = true
		solid_sprite.region_rect = sprite.region_rect
		solid_sprite.show()
		solid_animation_player.play("blink")

func choose_buff() -> void:
	var chance: float = randf()

	if 0.9 <= chance and chance <= 1.0:
		generate_mine()
	elif 0.8 <= chance and chance <= 0.9:
		solid_buff = true

func _play_sound(sound: AudioStreamWAV) -> void:
	sound_player.pitch_scale = randf_range(0.8, 1.2)
	sound_player.stream = sound
	sound_player.play()

func _set_state(state) -> void:
	match state:
		FIGURE_STATES.SOLID:
			freeze = true
			set_collision_layer_value(2, true)
			linear_velocity = Vector2.ZERO
			solid_animation_player.stop()
			GlobalEvents.figure_done.emit(self)
			GlobalEvents.camera_shake.emit()
		FIGURE_STATES.HANG:
			freeze = true
		FIGURE_STATES.FALL:
			freeze = false
			target_x = position.x
			modulate.a = 1
		FIGURE_STATES.IDLE:
			set_collision_layer_value(2, true)
			gravity_scale = 1
			sound_player.stream = FIGURE_SET_SOUND
			sound_player.play()
			GlobalEvents.figure_done.emit(self)
			GlobalEvents.camera_shake.emit()
	current_state = state

func _physics_process(delta):
	var vel: Vector2
	var rotation_diff: float
	var moving_diff: float

	move_timer += delta

	match current_state:

		FIGURE_STATES.FALL:
			vel = linear_velocity
			vel.y = fall_speed

			if Input.is_action_pressed("let_go"):
				vel.y *= fast_fall_multiplier
				if Input.is_action_just_pressed("let_go"):
					_play_sound(FIGURE_MOVE_SOUND)

			if not moving_to_side and move_timer > move_cooldown:
				if Input.is_action_pressed("move_right"):
					moving_to_side = true
					target_x = position.x + side_step
					if Input.is_action_just_pressed("move_right"):
						_play_sound(FIGURE_MOVE_SOUND)
				elif Input.is_action_pressed("move_left"):
					moving_to_side = true
					target_x = position.x - side_step
					if Input.is_action_just_pressed("move_left"):
						_play_sound(FIGURE_MOVE_SOUND)
			if not rotating:
				if Input.is_action_just_pressed("rotate_left"):
					target_rotation += deg_to_rad(90)
					rotating = true
					_play_sound(FIGURE_MOVE_SOUND)
				elif Input.is_action_just_pressed("rotate_right"):
					target_rotation -= deg_to_rad(90)
					rotating = true
					_play_sound(FIGURE_MOVE_SOUND)

			if rotating:
				rotation_diff = wrapf(target_rotation - rotation, -PI, PI)
				if abs(rotation_diff) < 0.01:
					angular_velocity = 0
					rotation = target_rotation
					rotating = false
				else:
					angular_velocity = rotation_diff * rotate_speed

			if moving_to_side:
				moving_diff = target_x - position.x
				if abs(moving_diff) < 5.0:
					vel.x = 0
					position.x = target_x
					moving_to_side = false
					move_timer = 0
				else:
					vel.x = sign(moving_diff) * side_move_speed
			
			if Input.is_action_just_pressed("apply") and solid_buff and not overlap_area.get_overlapping_areas():
				current_state = FIGURE_STATES.SOLID

			linear_velocity = vel

func _set_idle_tmer(body: Node2D) -> void:
	if body != self and current_state == FIGURE_STATES.FALL:
		idle_timer.start()

func set_idle() -> void:
	if solid_buff:
		current_state = FIGURE_STATES.SOLID
	else:
		current_state = FIGURE_STATES.IDLE

func _on_move_away_area_entered(_area: Area2D) -> void:
	GlobalEvents.figure_done.emit(self)
	GlobalEvents.take_damage.emit()
	remove_timer.start()

func generate_mine() -> void:
	var spawn_point: RayCast2D
	var mine: Area2D

	spawn_point = mine_points.get_children().pick_random()
	mine = MINE.instantiate()
	add_child(mine)
	mine.global_position = spawn_point.global_position
	mine.rotation = spawn_point.target_position.normalized().angle()

func remove_figure() -> void:
	queue_free()
