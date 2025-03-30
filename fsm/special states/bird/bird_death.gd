class_name BirdDeath
extends State

@export var actor : CharacterBody2D
@export var enemy_health_comp : Node2D


func enter() -> void:
	print("Enemy Entered Death State")
	actor.play_animation("enemy-dead")

	actor.set_physics_process(false)
	actor.set_process_input(false)
	actor.set_collision_layer_value(1, false)
	actor.set_collision_mask_value(1, false)

func physics_update(delta: float) -> void:
	pass


func exit() -> void:
	pass
