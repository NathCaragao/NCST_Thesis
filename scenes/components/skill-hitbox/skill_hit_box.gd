class_name SkillHitbox
extends Area2D
@export var skill_dmg : int
func _init() -> void:
	collision_layer = 2 
	collision_mask = 0
