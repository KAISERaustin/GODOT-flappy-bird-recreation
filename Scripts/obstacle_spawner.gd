extends Node2D

@onready var timer: Timer = $Timer

@export var Obstacle = preload("res://Scenes/obstacle.tscn") 

func _ready():
	randomize()

func _on_timer_timeout() -> void:
	spawn_obstacle()

func spawn_obstacle():
	var obstacle = Obstacle.instantiate()
	add_child(obstacle)
	
	#get a random number between 150 and 500
	obstacle.position.y = randi() % 350 + 150

func start():
	timer.start()
	
func stop():
	timer.stop()
