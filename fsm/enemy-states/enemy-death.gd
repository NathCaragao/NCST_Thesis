class_name EnemyDeath
extends State

# references and variables
@export var actor : CharacterBody2D
@export var enemy_health_comp : Node2D
@export var body_collision : CollisionShape2D


func enter() -> void:
	print("Enemy Entered Death State")
	# plays the death animation
	actor.play_animation("enemy-dead")
	
	
	# disable all phyics interactions
	body_collision.set_deferred("disabled", true)
	actor.hurt_box_shape.set_deferred("disablded", true)
	actor.hurt_box_shape.set_deferred("monitoring", false)
	actor.hurt_box_shape.set_deferred("monitorable", false)
	
	# disable other processes
	actor.set_physics_process(false)
	actor.set_process_input(false)
	actor.set_collision_layer_value(1, false)
	actor.set_collision_mask_value(1, false)

func physics_update(delta: float) -> void:
	# do nothing we're dead
	pass


func exit() -> void:
	# no such thing as exiting, bro's dead already
	pass
