class_name Hitbox
extends Area2D
var total_dmg: float
@export var attack_component: Node2D
func _ready() -> void:
	total_dmg = attack_component.base_dmg
func _init() -> void:
	collision_layer = 2
	collision_mask = 1
