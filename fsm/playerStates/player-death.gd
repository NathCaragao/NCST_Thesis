class_name PlayerDeath
extends State

# references
@export var actor : CharacterBody2D
@onready var death : AudioStreamPlayer2D = $"../../player_sound/death"

func enter() -> void:
	print("PLAYER DIED")
	actor.animation_player.play("player-dead")
	death.play()
	
	# disable all phyics interactions
	$"../../PlayerHealthComponent/Hurtbox/CollisionShape2D".set_deferred("disabled", true)
	
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
