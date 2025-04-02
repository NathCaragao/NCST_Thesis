class_name FireHazzardHitbox
extends Area2D
@export var fire_dmg = 20
func _ready() -> void:
	pass
func _init() -> void:
	collision_layer = 2
	collision_mask = 1
