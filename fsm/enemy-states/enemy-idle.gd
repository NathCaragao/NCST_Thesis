class_name EnemyIdle
extends State

# references and variables
@export var actor : Enemy

func enter() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# putting the gravity to the actor
	actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()
	
	if actor.velocity.x == 0:
		actor.animation_player.play("wolf-idle")
	
	# transitions to other states
	
	# transitions to enemy-follow
