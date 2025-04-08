extends StaticBody2D

class_name Pipe

@onready var collision_2d: CollisionShape2D = $CollisionShape2D
@onready var pipe_sprite: Sprite2D = $PipeBodySprite

const TOP_PIPE_HEIGHT = 16

@export var height = 32

func _ready():
	
	var region_rect = Rect2(pipe_sprite.region_rect)
	region_rect.size = Vector2(32, height - TOP_PIPE_HEIGHT)
	pipe_sprite.region_rect = region_rect
	pipe_sprite.position = Vector2(0, height / 2.0)
	
	var shape = RectangleShape2D.new()
	shape.size = Vector2(32, height)
	collision_2d.shape = shape
	collision_2d.position = Vector2(0, height / 2.0 - TOP_PIPE_HEIGHT / 2.0)
