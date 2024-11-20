class_name BirdWander
extends State

@export var actor : CharacterBody2D
@export var enemy_health_comp : Node2D
@export var timer : Timer
@onready var player = get_tree().get_first_node_in_group("Player")

# enemy reference
@export var speed : int = 30 # speed of the enemy
var dir: Vector2 # direction
var is_chase : bool
var direction
@export var player_distance : int = 90

func randomize_wander() -> void:
	pass

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_bird_dead1"))
	is_chase = false

func enter() -> void:
	pass

# updates the move function
func update(delta: float) -> void:
	move(delta)
	actor.play_animation("enemy-run")
	actor.flip_sprite()

func physics_update(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
	
	
	# state transitions
	if direction.length() < player_distance:
		Transitioned.emit(self, "birdfollow")

func on_bird_dead1() -> void:
	Transitioned.emit(self, "enemydeath")

# move function
func move(delta: float) -> void:
	if !is_chase:
		actor.velocity += dir * speed * delta
		actor.move_and_slide()

func _on_timer_timeout() -> void:
	timer.wait_time = choose([1.0, 1.5, 2.0])
	# when the time runs out
	# free roam the enemy and choose random direction
	if !is_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN])
		print(dir)

func choose(array: Array):
	array.shuffle()
	return array.front()
	
