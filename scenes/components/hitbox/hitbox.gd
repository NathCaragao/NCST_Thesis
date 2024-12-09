class_name Hitbox
extends Area2D

var total_dmg : float
@onready var attack_component: AttackComponent = $"../AttackComponent"

func _ready() -> void:
	total_dmg = attack_component.weap_dmg + attack_component.base_dmg

func _init() -> void:
	collision_layer = 2 # set to hitbox layer
	collision_mask = 1
