class_name DeathZone
extends Area2D

@export var insta_dmg : int = 100

func _init() -> void:
	collision_layer = 2 # set to hitbox layer
	collision_mask = 1
