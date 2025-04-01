class_name BossAttack
extends State
@export var boss_attack_audio_node: NodePath
@export var actor : CharacterBody2D
@export var move_speed : float = 20.0
@export var enemy_health_comp : Node2D
@export var timer : Timer
@onready var player = get_tree().get_first_node_in_group("Player")
var direction
func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead3"))
func enter() -> void:
	direction = player.global_position - actor.global_position
	print("Entered attack state")
	print("Player position:", player.global_position)
	print("Actor position:", actor.global_position)
	print("Direction length:", direction.length())
	print("Within attack range, playing attack animation")
	actor.play_animation("enemy-attack1")
	if boss_attack_audio_node:
			var boss_audio_node = get_node(boss_attack_audio_node) as AudioStreamPlayer2D
			if boss_audio_node:
				boss_audio_node.play()
	timer.start()
func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		direction.y = 0
	direction.y = 0
	if direction.length() > 41:
		Transitioned.emit(self, "enemyfollow")
	elif direction.length() > 110:
		Transitioned.emit(self, "enemywander")
func on_enemy_dead3() -> void:
	timer.stop()
	Transitioned.emit(self, "enemydeath")
func on_hit1() -> void:
	Transitioned.emit(self, "enemyhit")
func _on_timer_timeout() -> void:
	actor.play_animation("enemy-attack2")
func exit() -> void:
	pass
