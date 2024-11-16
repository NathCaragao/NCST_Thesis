class_name EnemyIdle
extends State

# references and variables
@export var actor : CharacterBody2D
var player : PlayerHercules
var direction

func enter() -> void:
	actor.play_animation("enemy-idle")

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# putting the gravity to the actor
	actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()
	
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		# Set the y-component to 0 to restrict movement to the x-axis (horizontal only)
		direction.y = 0
	
	if actor.velocity.x == 0:
		actor.play_animation("enemy-idle")
	
	actor.flip_sprite()
	
	# transitions to other states
	if direction.length() < 90:
		print("ENEMY is following the player")
		Transitioned.emit(self, "enemyfollow")
	
	# transitions to enemy-follow
