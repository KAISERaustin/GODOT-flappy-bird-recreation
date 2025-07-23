extends CharacterBody2D
class_name Player

@onready var area_2d: Area2D                      = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer    = $AnimationPlayer
@onready var character_body_2d: CharacterBody2D   = $"."
@onready var time_to_rotate_down: Timer           = $time_to_rotate_down
@onready var audio_jump: AudioStreamPlayer2D      = $jump
@onready var ground_death: AudioStreamPlayer2D    = $ground_death

# Autoloaded manager that does the freeze+fade+scene swap
@onready var SceneManager = get_node("/root/SceneManager")

var SPEED = 200.0
const JUMP_VELOCITY = -425.0

var is_a_loser = false
var ready_to_rotate_down = true

func _ready() -> void:
	# Ensure we still get input events even if time_scale == 0
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_input(true)

func _input(event: InputEvent) -> void:
	# 1) On Android, any screen touch = jump
	if event is InputEventScreenTouch and event.pressed:
		_attempt_jump()
	# 2) On desktop/editor, left-click anywhere = jump
	elif event is InputEventMouseButton	and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_attempt_jump()

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# also allow the existing “jump” action (e.g. spacebar)
	if Input.is_action_just_pressed("jump"):
		_attempt_jump()

	move_and_slide()

func _attempt_jump() -> void:
	if is_a_loser or is_on_ceiling():
		return

	# your existing jump/animation logic
	animation_player.play("default")
	audio_jump.play()
	character_body_2d.rotation_degrees = -20
	velocity.y = JUMP_VELOCITY
	time_to_rotate_down.start()
	animated_sprite_2d.play("moving")
	if ready_to_rotate_down:
		ready_to_rotate_down = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		die()

func _on_time_to_rotate_down_timeout() -> void:
	animation_player.play("falling_for_long_time")
	ready_to_rotate_down = true

func die() -> void:
	ground_death.play()
	animated_sprite_2d.stop()
	is_a_loser = true

	# this freezes everything (time_scale=0), fades out, then back to menu
	SceneManager.change_scene("res://Scenes/main_menu.tscn")
