extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_body_2d: CharacterBody2D = $"."
@onready var time_to_rotate_down: Timer = $time_to_rotate_down
@onready var audio_jump: AudioStreamPlayer2D = $jump
@onready var ground_death: AudioStreamPlayer2D = $ground_death
@onready var load_up_main_menu: Timer = $load_up_main_menu

var SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_a_loser = false
var ready_to_rotate_down = true

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#grabs the input, checks if on the ceiling, checks if they collided with a forbidden area!
	if Input.is_action_just_pressed("jump") and not is_on_ceiling() and not is_a_loser:
		animation_player.play("default")
		audio_jump.play()
		character_body_2d.rotation_degrees = -20
		velocity.y = JUMP_VELOCITY
		time_to_rotate_down.start()
		animated_sprite_2d.play("moving")
		if ready_to_rotate_down:
			ready_to_rotate_down = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = .5
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		ground_death.play()
		animated_sprite_2d.stop()
		is_a_loser = true
		SPEED = 0
		load_up_main_menu.start()
		
		
func _on_time_to_rotate_down_timeout() -> void:
	animation_player.play("falling_for_long_time") 
	ready_to_rotate_down = true


func _on_load_up_main_menu_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
