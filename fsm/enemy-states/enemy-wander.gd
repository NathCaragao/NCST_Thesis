class_name EnemyWander
extends State
# references and variables
@export var actor : CharacterBody2D
@export var move_speed : float = 10.0
@onready var player = get_tree().get_nodes_in_group("Player")
var is_signal_connected : bool = false
var direction
@export var player_distance : int = 110
var move_direction : Vector2
var wander_time : float
@export var enemy_health_comp : Node2D

func find_valid_player() -> Node2D:
	for player in player:
		if is_instance_valid(player):
			return player
	return null

func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 2)

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_enemy_dead1"))

func enter() -> void:
	randomize_wander()

func update(delta: float) -> void:
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta: float) -> void:
	var player = find_valid_player()
	
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# Set the y-component to 0 to restrict movement to the x-axis (horizontal only)
		direction.y = 0
	
	if actor:
		# Apply gravity
		if not actor.is_on_floor():
			actor.velocity.y += actor.gravity * delta
			# Change to idle animation when falling
			actor.play_animation("enemy-idle")
		else:
			# Horizontal movement only when on floor
			actor.velocity.x = move_direction.x * move_speed
			actor.play_animation("enemy-run")
		
		actor.flip_sprite()
		actor.move_and_slide()
	
	# transitions to enemy follow
	if player and direction and direction.length() < player_distance:
		print("ENEMY is following the player")
		Transitioned.emit(self, "enemyfollow")

# transitions to enemy death
func on_enemy_dead1() -> void:
	Transitioned.emit(self, "enemydeath")
