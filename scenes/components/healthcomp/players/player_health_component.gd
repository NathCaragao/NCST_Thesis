class_name PlayerHpComp
extends Node2D

@export var max_health : float = 100.0
var current_health : float
# reference player hurtbox here
var is_dead : bool = false
@onready var phealth_bar: ProgressBar = $Hp_bar/PlayerHPbar
@export var anim_effects: AnimationPlayer
@export var player: PlayerHercules


signal ObstacleHit
signal PlayerDead

func _ready() -> void:
	clamp_health()
	current_health = max_health
	
	phealth_bar.init_health(max_health)

func take_damage(amount: float) -> void:
	# damage calculation with def stat
	var damage_reduction = player.defense / (player.defense + 10.0)
	var reduced_damage = max(amount * (1.0 - damage_reduction), 0)
	
	current_health -= reduced_damage
	clamp_health()
	# update health bar value here
	phealth_bar.health = current_health
	
	print("took damage ")
	print("current health: ", current_health)
	anim_effects.play("hit-flash")
	emit_signal("ObstacleHit")
	
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
	phealth_bar.health = current_health
