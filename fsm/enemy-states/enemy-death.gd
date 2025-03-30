class_name EnemyDeath
extends State

@export var actor : CharacterBody2D
@export var enemy_health_comp : Node2D
@export var death_audio_node: NodePath

func enter() -> void:
	print("Enemy Entered Death State")
	actor.play_animation("enemy-dead")
	if death_audio_node:
		var death_node = get_node(death_audio_node) as AudioStreamPlayer2D
		if death_node:
			death_node.play()
	
	actor.set_physics_process(false)
	actor.set_process_input(false)
	actor.set_collision_layer_value(1, false)
	actor.set_collision_mask_value(1, false)

func physics_update(delta: float) -> void:
	pass


func exit() -> void:
	pass
