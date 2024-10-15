class_name AttackComponent
extends Node2D

@export var base_dmg : int = 10
@export var weap_dmg : int
@export var knockback_force : float = 100.0
var knockback_pos : Vector2

func apply_damage(target):
	if target.has_method("take_damage"):
		target.take_damage(base_dmg)
