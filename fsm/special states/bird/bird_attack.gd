class_name BirdAttack
extends State
@export var actor : CharacterBody2D
@export var move_speed : float = 20.0
@export var enemy_health_comp : Node2D
@export var timer : Timer
@onready var player = get_tree().get_first_node_in_group("Player")
var direction
@export var player_length : int = 40
func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead3"))
func enter() -> void:
	direction = player.global_position - actor.global_position
	print("Entered attack state")
	print("Player position:", player.global_position)
	print("Actor position:", actor.global_position)
	print("Direction length:", direction.length())
	if direction.length() < player_length:
		print("Within attack range, playing attack animation")
		actor.play_animation("enemy-attack")
		timer.start()
	else:
		print("Not within attack range")
func physics_update(delta: float) -> void:
	actor.velocity.y += actor.gravity * delta
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		direction.y = 0
	direction.y = 0
	if direction.length() > 40:
		Transitioned.emit(self, "birdfollow")
	elif direction.length() > 110:
		Transitioned.emit(self, "birdwander")
func on_enemy_dead3() -> void:
	timer.stop()
	Transitioned.emit(self, "birddeath")
func on_hit1() -> void:
	Transitioned.emit(self, "enemyhit")
func _on_timer_timeout() -> void:
	actor.play_animation("enemy-attack")
func exit() -> void:
	pass
