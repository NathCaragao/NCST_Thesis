class_name AtalantaIdle
extends State

@export var actor : CharacterBody2D
@export var player_health_component: PlayerHpComp
@export var idle : AudioStreamPlayer2D
@onready var delay_timer = $Timer

func enter() -> void:
	print("Entered Idle State")
	delay_timer.start()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if actor.playerGameData.isControlled:
		actor.velocity.y += actor.gravity * delta
	else:
		actor.velocity.y = actor.playerGameData.velocity.y
	
	actor._flip_sprite()
	actor.move_and_slide()
	
	if actor.playerGameData.velocity.x == 0:
		actor.animation_player.play("idle")
	
	if player_health_component.current_health == 0:
		Transitioned.emit(self, "atalantadeath")
	
	if actor.playerGameData.isControlled:
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			Transitioned.emit(self, "atalantarun")
		
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "atalantajump")
		
		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "atalantaattack")
		
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "atalantaskill")
	
	else:
		if actor.playerGameData.velocity.x != 0:
			Transitioned.emit(self, "atalantarun")
		
		if actor.playerGameData.isJumping:
			Transitioned.emit(self, "playerjump")
		
		if actor.playerGameData.isAttacking:
			Transitioned.emit(self, "atalantaattack")
		
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "atalantaskill")


func _on_timer_timeout():
	idle.play()
	
	delay_timer.start()
