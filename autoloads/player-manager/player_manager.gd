# player manager.gd
extends Node

signal StatUpgraded

# player stats
var player_move_speed : float = 200.0
var player_weapon_dmg : float = 3.0
var player_attack : float = 10.0
var player_defense : float = 10.0
var player_health : float = 100.0
var coins : int = 100
var gems: int = 0

var attackUpgradeLevel: int = 0
var defenseUpgradeLevel: int = 0
var speedUpgradeLevel: int = 0
var healthUpgradeLevel: int = 0

var character_info : bool = false
