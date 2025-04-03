class_name SpikeHitbox
extends Area2D
@export var spike_dmg : int = 20
func _ready() -> void:
	pass
func _init() -> void:
	collision_layer = 2
	collision_mask = 1
