class_name PlayerHpComp
extends Node2D

@export var max_health : int = 100
var current_health : int
# reference player hurtbox here
var is_dead : bool = false

signal PlayerDead

func _ready() -> void:
	current_health = max_health
	clamp_health()
	#health_bar.init_health(max_health)

func take_damage(amount: int) -> void:
	current_health -= amount
	clamp_health()
	# update health bar value here
	#health_bar.health = max_health
	
	print("took damage ")
	print("current health: ", current_health)
	
	if current_health <= 0:
		on_player_died()

func on_player_died() -> void:
	emit_signal("PlayerDead")

# clamp health to prevent negative value
func clamp_health() -> void:
	current_health = clamp(current_health, 0, max_health)

# for reviving or respawing
func reset_health() -> void:
	current_health = max_health
	is_dead = false
	# player_hp_bar.health = current_health
