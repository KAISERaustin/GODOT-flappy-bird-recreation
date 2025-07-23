extends Node2D

signal score

const SPEED = 275
var yo_this_bird_dead = false

func pause_game() -> void:
	get_tree().paused = true
	print("Game is paused.")

func unpause_game() -> void:
	get_tree().paused = false
	print("Game is resumed.")

func _physics_process(delta: float) -> void:
	if !yo_this_bird_dead:
		position.x += -SPEED * delta
		if global_position.x <= -150:
			queue_free()

func _on_pipe_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.has_method("die"):
			_physics_process(false)
			yo_this_bird_dead = true
			body.die()
			pause_game()

func _on_score_area_body_exited(body: Node2D) -> void:
	if body is Player:
		emit_signal("score")
