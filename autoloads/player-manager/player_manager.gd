# player manager.gd
extends Node

signal StatUpgraded

# Player Base Stats (CONSTANT , DOES NOT CHANGE)
var base_health : float = 200.0
var base_attack : float = 10.0
var base_weapon_dmg : float = 3.0
var base_defense : float = 10.0
var base_speed : float = 200.0

# Modifiable player stats
var player_move_speed : float = base_speed
var player_weapon_dmg : float = base_weapon_dmg
var player_attack : float = base_attack
var player_defense : float  = base_defense
var player_health : float = base_health
var coins : int = 100
var gems: int = 0

var attackUpgradeLevel: int = 0
var defenseUpgradeLevel: int = 0
var speedUpgradeLevel: int = 0
var healthUpgradeLevel: int = 0

var character_info : bool = false

func reset_to_base_stats() -> void:
	player_health = base_health
	player_attack = base_attack
	player_defense = base_defense
	player_move_speed = base_speed
