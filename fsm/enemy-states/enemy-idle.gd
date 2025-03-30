class_name EnemyIdle
extends State


@export var actor : CharacterBody2D
var player : PlayerHercules
var direction

func enter() -> void:
	actor.play_animation("enemy-idle")

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()
	
	if is_instance_valid(player) and is_instance_valid(actor):
		direction = player.global_position - actor.global_position
		
		direction.y = 0
	
	if actor.velocity.x == 0:
		actor.play_animation("enemy-idle")
	
	actor.flip_sprite()
	
	if direction.length() < 90:
		print("ENEMY is following the player")
		Transitioned.emit(self, "enemyfollow")
	
