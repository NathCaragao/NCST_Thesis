class_name BirdWander
extends State

@export var actor : CharacterBody2D
@export var move_speed : float = 10.0
@export var enemy_health_comp : Node2D

var player : PlayerHercules
var is_signal_connected : bool = false
var direction : Vector2
var move_direction : Vector2
var wander_time : float

# Optional: Add height constraints for the bird
@export var min_height : float = 50.0  # Adjust these values
@export var max_height : float = 200.0 # based on your game

func randomize_wander() -> void:
	var new_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	move_direction = move_direction.lerp(new_direction, 0.5)
	wander_time = randf_range(1, 2)

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead1"))

func enter() -> void:
	randomize_wander()
	player = get_tree().get_first_node_in_group("Player")

func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# For flying enemies, we want to keep the y direction
		# Remove this line since birds should move vertically:
		# direction.y = 0
		
		# Check if player is within range
		if direction.length() < 120:
			print("ENEMY is following the player")
			Transitioned.emit(self, "enemyfollow")
	
	if actor:
		# Remove gravity for flying enemies
		# actor.velocity.y += actor.gravity * delta  # Remove this line
		
		# Apply movement
		actor.velocity = move_direction * move_speed
		actor.play_animation("enemy-run")  # You might want to change this to a flying animation
		actor.flip_sprite()
		
		# Optional: Add height constraints
		if actor.global_position.y < min_height:
			actor.velocity.y = max(0, actor.velocity.y)
		elif actor.global_position.y > max_height:
			actor.velocity.y = min(0, actor.velocity.y)
		
		actor.move_and_slide()

func on_enemy_dead1() -> void:
	Transitioned.emit(self, "enemydeath")
