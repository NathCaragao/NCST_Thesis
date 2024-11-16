class_name BirdFollow
extends State

@export var actor : CharacterBody2D
@export var move_speed : float = 100.0
@export var enemy_health_comp : Node2D

var player : PlayerHercules
var direction : Vector2
@export var min_height : float = 50.0
@export var max_height : float = 200.0

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead2"))

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")

func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# Simplified following logic
		var target_position = player.global_position + Vector2(0, -40)  # Fly 40 pixels above player
		direction = target_position - actor.global_position
		
		# Move directly towards target
		actor.velocity = direction.normalized() * move_speed
		
		# Apply height constraints
		if actor.global_position.y < min_height:
			actor.velocity.y = max(0, actor.velocity.y)
		elif actor.global_position.y > max_height:
			actor.velocity.y = min(0, actor.velocity.y)
		
		# Apply movement
		actor.move_and_slide()
		actor.play_animation("enemy-run")
		
		# Flip sprite based on movement direction
		if actor.velocity.x < 0:
			actor.scale.x = -1
		elif actor.velocity.x > 0:
			actor.scale.x = 1
		
		# Transitions
		var distance_to_player = actor.global_position.distance_to(player.global_position)
		if distance_to_player > 140:
			Transitioned.emit(self, "enemywander")
		elif distance_to_player <= 50:
			Transitioned.emit(self, "enemyattack")

func on_enemy_dead2() -> void:
	Transitioned.emit(self, "enemydeath")
