class_name BirdFollow
extends State

@export var actor : CharacterBody2D
@export var move_speed : float = 20.0
@export var enemy_health_comp : Node2D

var player : PlayerHercules
var direction : Vector2

# Optional: Add height constraints like in wander state
@export var min_height : float = 50.0
@export var max_height : float = 200.0

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead2"))

func enter() -> void:
	player = get_tree().get_first_node_in_group("Player")

func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# Remove these lines since we want the bird to follow in both X and Y
		# direction.y = 0  # Remove both instances of this line
		
		if direction.length() > 25:
			# Add some vertical offset to make the bird fly slightly above the player
			var target_position = player.global_position + Vector2(0, -20)  # Fly 20 pixels above player
			direction = target_position - actor.global_position
			
			actor.velocity = direction.normalized() * move_speed
			
			# Optional: Add height constraints
			if actor.global_position.y < min_height:
				actor.velocity.y = max(0, actor.velocity.y)
			elif actor.global_position.y > max_height:
				actor.velocity.y = min(0, actor.velocity.y)
			
			actor.move_and_slide()
			actor.play_animation("enemy-run")  # Consider changing to a flying animation
		
		# Flip sprite
		actor.flip_sprite()
		
		# Transitions
		if direction.length() > 110:
			Transitioned.emit(self, "enemywander")
		elif direction.length() <= 40:
			Transitioned.emit(self, "enemyattack")

func on_enemy_dead2() -> void:
	Transitioned.emit(self, "enemydeath")
