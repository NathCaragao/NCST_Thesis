class_name EnemyIdle
extends State

# references and variables
@export var actor : CharacterBody2D

func enter() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# putting the gravity to the actor
	actor.velocity.y += actor.gravity * delta
	
	if actor.velocity.x == 0:
		actor.play_animation("enemy-idle")
	
	# transitions to other states
	
	# transitions to enemy-follow
