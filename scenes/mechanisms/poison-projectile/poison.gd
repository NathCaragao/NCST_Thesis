class_name Poison
extends Node2D
@export var speed : float = 500.0
@onready var attack_component: AttackComponent = $AttackComponent as AttackComponent
@export var tracking_time: float = 1.5 
@export var tracking_speed: float = 3.0  
@export var gravity: float = 400.0  
@onready var player = get_tree().get_first_node_in_group("Player")
@export var drag: float = 0.98 
var vel : float
var total_dmg : int
var has_hit : bool = false
var tracking: bool = true
var initial_direction: Vector2
var velocity: Vector2
func _ready() -> void:
	var timer = get_tree().create_timer(tracking_time)
	timer.timeout.connect(_on_tracking_timer_timeout)
	initial_direction = Vector2(vel, 0)
func _physics_process(delta: float) -> void:
	if tracking and player:
		var direction_to_player = global_position.direction_to(player.global_position)
		initial_direction = initial_direction.lerp(direction_to_player, tracking_speed * delta)
		position += initial_direction * speed * delta
	else:
		move_local_x(vel * speed * delta)
func _on_tracking_timer_timeout() -> void:
	tracking = false
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
