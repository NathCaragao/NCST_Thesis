class_name BirdFollow
extends State

@export var actor : CharacterBody2D
@export var move_speed : int = 70
@export var enemy_health_comp : Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
var direction : Vector2
@export var min_height : float = 50.0
@export var max_height : float = 200.0

func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_bird_dead2"))

func enter() -> void:
	print("Entered Bird Follow")

func physics_update(delta: float) -> void:
	actor.move_and_slide()
	
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position

func on_bird_dead2() -> void:
	Transitioned.emit(self, "enemydeath")
