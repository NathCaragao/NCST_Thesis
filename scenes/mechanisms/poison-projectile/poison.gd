class_name Poison
extends Node2D

@export var speed : float = 500.0
@onready var attack_component: AttackComponent = $AttackComponent as AttackComponent

@export var tracking_time: float = 1.5  # How long the projectile tracks the player
@export var tracking_speed: float = 3.0  # How fast it turns toward player
@export var gravity: float = 400.0  # Controls how fast it falls
@onready var player = get_tree().get_first_node_in_group("Player")
@export var drag: float = 0.98 

var vel : float
var total_dmg : int
var has_hit : bool = false
var tracking: bool = true
var initial_direction: Vector2
var velocity: Vector2

func _ready() -> void:
	# Start a timer to stop tracking after tracking_time seconds
	var timer = get_tree().create_timer(tracking_time)
	timer.timeout.connect(_on_tracking_timer_timeout)
	# Store initial direction
	initial_direction = Vector2(vel, 0)

func _physics_process(delta: float) -> void:
	#move_local_x(vel * speed * delta)
	
	if tracking and player:
		# Get direction to player
		var direction_to_player = global_position.direction_to(player.global_position)
		
		# Smoothly interpolate between current direction and direction to player
		initial_direction = initial_direction.lerp(direction_to_player, tracking_speed * delta)
		
		# Move in the interpolated direction
		position += initial_direction * speed * delta
	else:
		# After tracking time, continue in last direction
		move_local_x(vel * speed * delta)
		## After tracking ends:
		## 1. Apply gravity
		#velocity.y += gravity * delta
		#
		## 2. Apply drag/air resistance
		#velocity *= drag
		#
		## 3. Move with current velocity
		#position += velocity * delta
		#
		## 4. Optional: Rotate the projectile to face its movement direction
		#rotation = velocity.angle()

func _on_tracking_timer_timeout() -> void:
	tracking = false

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
