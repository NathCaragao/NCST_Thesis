class_name PlayerSkill
extends State

# references
@export var actor : PlayerHercules

func enter() -> void:
	actor.velocity = Vector2.ZERO
	actor.animation_player.play("skill01")

func physics_update(delta: float) -> void:
	actor.velocity.y += actor.gravity * delta
	
	if not actor.animation_player.is_playing():
		# Animation ended, decide what to do next
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			Transitioned.emit(self, "playerrun")
		
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "playerjump")
		
		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "playerattack")
		
		else:
			Transitioned.emit(self, "playeridle")
