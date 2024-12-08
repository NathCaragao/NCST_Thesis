class_name AttackComponent
extends Node2D

var base_dmg : float = PlayerManager.player_attack
@export var weap_dmg : int
@export var knockback_force : float = 500.0
var knockback_pos : Vector2

func apply_damage(target):
	if target.has_method("take_damage"):
		target.take_damage(base_dmg)
