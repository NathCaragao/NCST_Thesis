class_name BirdFollow
extends State
@export var actor : CharacterBody2D
@export var move_speed : float = 50.0
@export var enemy_health_comp : Node2D
var player : PlayerHercules  # Match the type with BirdWander
var direction : Vector2
@export var min_height : float = 50.0
@export var max_height : float = 200.0
@export var player_distance : int = 110
@export var min_follow_distance : float = 20.0  # Add minimum distance to prevent sticking

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_bird_dead2"))

func enter() -> void:
	print("BIRD FOLLOW")
	player = get_tree().get_first_node_in_group("Player")

func update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		actor.play_animation("enemy-run")
		actor.flip_sprite()

func physics_update(delta: float) -> void:
	if !is_instance_valid(player) or !is_instance_valid(actor):
		return
		
	direction = player.global_position - actor.global_position
	
	if direction.length() > player_distance + 20:  # Add a small buffer
		Transitioned.emit(self, "birdwander")
	
	if direction.length() < min_follow_distance:
		Transitioned.emit(self, "birdattack")
	
	# Calculate velocity
	var move_direction = direction.normalized()
	var distance_to_player = direction.length()
	
	if distance_to_player > min_follow_distance:
		actor.velocity = move_direction * move_speed
	else:
		# Circle around or maintain distance when too close
		var perpendicular = Vector2(-move_direction.y, move_direction.x)
		actor.velocity = perpendicular * move_speed
	
	# Apply height constraints like in BirdWander
	if actor.global_position.y < min_height:
		actor.velocity.y = max(0, actor.velocity.y)
	elif actor.global_position.y > max_height:
		actor.velocity.y = min(0, actor.velocity.y)
	
	actor.move_and_slide()

func on_bird_dead2() -> void:
	Transitioned.emit(self, "birddeath")
