class_name EnemyHit
extends State

# references and variables
@export var actor : CharacterBody2D
@export var enemy_health : EnemyHealthComp
@export var attack : Node2D
@onready var player = get_tree().get_nodes_in_group("Player")


var is_knocked_back: bool = false
var deceleration: float = 800.0

func _ready() -> void:
	
	enemy_health.connect("Hit", Callable(self, "on_hit"))

func enter() -> void:
	pass

func find_valid_player() -> Node2D:
	for player in player:
		if is_instance_valid(player):
			return player
	return null

func physics_update(delta: float) -> void:
	# Add the gravity.
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	
	var player = find_valid_player()
	
	if is_knocked_back:
		# Decelerate the velocity
		actor.velocity.x = move_toward(actor.velocity.x, 0, deceleration * delta)

		# Apply the movement with deceleration
		actor.move_and_slide()

		# If velocity is very small, stop knockback
		if abs(actor.velocity.x) < 0.1:
			is_knocked_back = false
			actor.velocity = Vector2.ZERO

func on_hit() -> void:
	actor.play_animation("enemy-hit")
	print("Enemy got HIT")
	freeze_time(0.4, 0.15)
	knock_back()

func knock_back() -> void:
	# enemy knockback
	var player = find_valid_player()
	
	if player:
		var knockback_direction = (actor.global_position - player.global_position).normalized()
		knockback_direction.y = 0 # ensure 0 to keep the knockback horizontal
		
		actor.velocity = knockback_direction * attack.knockback_force

		actor.move_and_slide()
		
		is_knocked_back = true

# gets activated when the enemy gets hit
func freeze_time(timescale, duration) -> void:
	Engine.time_scale = timescale
	await(get_tree().create_timer(duration * timescale).timeout)
	Engine.time_scale = 1.0


func exit() -> void:
	is_knocked_back = false
