class_name RazorHitbox
extends Area2D

@export var razor_dmg : int = 10

func _ready() -> void:
	pass

func _init() -> void:
	collision_layer = 2
	collision_mask = 1
