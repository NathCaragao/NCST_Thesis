class_name PlayerDeath
extends State

# references
@export var actor : PlayerHercules

func enter() -> void:
	print("PLAYER DIED")
	actor.animation_player.play("player-dead")
	
	# disable all phyics interactions
	$"../../PlayerHealthComponent/Hurtbox/CollisionShape2D".disabled = true
	
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
