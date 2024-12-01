class_name PlayerHit
extends State

# references and variables
@export var actor : CharacterBody2D
@export var health_comp : PlayerHpComp
@onready var on_hit : AudioStreamPlayer2D = $"../../player_sound/on_hit"
func _ready() -> void:
	health_comp.connect("ObstacleHit", Callable(self, "on_obstacle_hit"))


func physics_update(delta: float) -> void:
	pass


func freeze_time(timescale, duration) -> void:
	Engine.time_scale = timescale
	await(get_tree().create_timer(duration * timescale).timeout)
	Engine.time_scale = 1.0

func on_obstacle_hit() -> void:
	freeze_time(0.1, 0.4)
	on_hit.play()
