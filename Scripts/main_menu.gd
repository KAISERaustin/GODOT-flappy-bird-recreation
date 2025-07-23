extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unpause_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func pause_game() -> void:
	get_tree().paused = true
	print("Game is paused.")

func unpause_game() -> void:
	get_tree().paused = false
	print("Game is resumed.")
