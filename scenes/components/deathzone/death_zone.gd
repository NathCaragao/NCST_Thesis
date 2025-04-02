class_name DeathZone
extends Area2D
@export var insta_dmg: int = 1000
func _init() -> void:
	collision_layer = 2
	collision_mask = 1
