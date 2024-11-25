class_name PlayerSkill
extends State

# references
@export var actor : CharacterBody2D
@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"

func enter() -> void:
	actor.velocity = Vector2.ZERO
	skill_activate()

func physics_update(delta: float) -> void:
	actor.velocity.y += actor.gravity * delta
	actor._flip_sprite()
	
	if not actor.animation_player.is_playing():
		# Animation ended, decide what to do next
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			Transitioned.emit(self, "playerrun")
		
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "playerjump")
		
		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "playerattack")
		
		if player_health_component.current_health == 0:
			Transitioned.emit(self, "playerdeath")
		else:
			Transitioned.emit(self, "playeridle")

func skill_activate() -> void:
	actor.animation_player.play("skill01")
