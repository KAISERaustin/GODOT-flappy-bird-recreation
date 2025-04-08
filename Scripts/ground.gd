extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("entered")
	if area.is_in_group("player"):
		print("Player")
		var player = area
		if not player.has_method("die"):
			player = area.get_parent()
		if player.has_method("die"):
			print("they have it")
			animation_player.stop()
			player.die()
