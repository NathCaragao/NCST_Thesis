class_name EnemyHealthComp
extends Node2D

# reference and variables
@export var max_health : int = 100
var current_health : int
@export var enemy_hp_bar : ProgressBar
@export var anim_effects : AnimationPlayer
@export var dmg_num_pos : Node2D

var is_dead : bool = false
# signals
signal EnemyDead
signal Hit

func _ready() -> void:
	current_health = max_health
	clamp_health()
	enemy_hp_bar.init_health(max_health)

func take_damage(amount: int) -> void:
	current_health -= amount
	emit_signal("Hit")
	anim_effects.play("hit-flash")
	DamageNumbers.display_number(amount, dmg_num_pos.global_position)
	
	clamp_health()
	enemy_hp_bar.health = current_health # updates the hp bar UI
	
	print("took damage ")
	print("current health: ", current_health)
	
	if current_health <= 0:
		enemy_died()
		ScoreManager.add_points("enemy")

func enemy_died() -> void:
	current_health = 0
	emit_signal("EnemyDead")

# clamp health to prevent negative value
func clamp_health() -> void:
	current_health = clamp(current_health, 0, max_health)

# for reviving or respawing
func reset_health() -> void:
	current_health = max_health
	is_dead = false
	enemy_hp_bar.health = max_health
