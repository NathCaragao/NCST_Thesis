extends Node

var current_scene_packed : PackedScene

func set_current_scene(scene: PackedScene):
	current_scene_packed = scene

func reset_level():
	if current_scene_packed:
		get_tree().change_scene_to_packed(current_scene_packed)
		print("die")
