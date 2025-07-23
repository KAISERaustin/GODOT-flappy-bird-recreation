extends Node

signal scene_changing
signal scene_loaded

@export var fade_layer_path: NodePath = "FadeLayer"
@export var fade_rect_path:  NodePath = "FadeLayer/ColorRect"
@export var fade_duration:   float   = 0.5

@onready var _fade_layer := get_node(fade_layer_path) as CanvasLayer
@onready var _fade_rect  := get_node(fade_rect_path)  as ColorRect

var _next_scene: String    = ""
var previous_scene: String = ""
var is_paused: bool        = false

func _ready() -> void:
	# keep running even if Engine.time_scale == 0
	process_mode = Node.PROCESS_MODE_ALWAYS
	_fade_layer.visible = false

func change_scene(path: String) -> void:
	# completely freeze the world
	Engine.time_scale = 0.0

	var cur = get_tree().current_scene
	if cur:
		previous_scene = cur.scene_file_path
	_next_scene = path
	emit_signal("scene_changing")

	_fade_layer.visible = true
	_fade_rect.modulate.a = 0.0

	# tween ignores time_scale, so fade happens while the world is frozen
	var tw = create_tween().bind_node(self).set_ignore_time_scale(true)
	tw.tween_property(_fade_rect, "modulate:a", 1.0, fade_duration)
	tw.tween_callback(Callable(self, "_on_fade_out_done"))

func _on_fade_out_done() -> void:
	if get_tree().change_scene_to_file(_next_scene) != OK:
		push_error("Couldn’t load: " + _next_scene)
		return

	# fade back in
	_fade_rect.modulate.a = 1.0
	var tw = create_tween().bind_node(self).set_ignore_time_scale(true)
	tw.tween_property(_fade_rect, "modulate:a", 0.0, fade_duration)
	tw.tween_callback(Callable(self, "_on_fade_in_done"))

func _on_fade_in_done() -> void:
	_fade_layer.visible = false
	# restore normal time flow
	Engine.time_scale = 1.0
	emit_signal("scene_loaded")

func go_back() -> void:
	if is_paused:
		Engine.time_scale = 1.0
		is_paused = false
	change_scene(previous_scene)

func reload_current() -> void:
	Engine.time_scale = 1.0
	var cur = get_tree().current_scene.scene_file_path
	change_scene(cur)
