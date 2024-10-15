class_name SkillHitbox
extends Area2D

@export var skill_dmg : int

func _ready() -> void:
	pass

func _init() -> void:
	collision_layer = 2 # set to hitbox layer
	collision_mask = 0
