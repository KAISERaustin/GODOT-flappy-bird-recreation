extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var SPEED = 300.0
const JUMP_VELOCITY = -400.0
var is_a_loser = false

func _physics_process(delta: float) -> void:
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#grabs the input, checks if on the ceiling, checks if they collided with a forbidden area!
	if Input.is_action_just_pressed("jump") and not is_on_ceiling() and not is_a_loser:
		animated_sprite_2d.sprite_frames.set_animation_loop("moving", true)
		animated_sprite_2d.play("moving")
		velocity.y = JUMP_VELOCITY
		#Animation stuff
		#var original_loop_state = animated_sprite_2d.loop
		animated_sprite_2d.sprite_frames.set_animation_loop("moving", false)
		#Await the animation_finished signal
		await(animated_sprite_2d.animation_finished)
		animation_player.play("falling_for_long_time")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = .5
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	  
func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		is_a_loser = true
		SPEED = 0
		
