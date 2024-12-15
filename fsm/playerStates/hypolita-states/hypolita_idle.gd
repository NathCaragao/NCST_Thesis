class_name HypolitaIdle
extends State

# references
@export var actor : CharacterBody2D
@export var player_health_component: PlayerHpComp
@export var idle : AudioStreamPlayer2D
@onready var delay_timer = $Timer

func enter() -> void:
	print("Entered Idle State")
	delay_timer.start()
	
func physics_update(delta: float) -> void:
	# Adjust velocity y(gravity)
	if actor.playerGameData.isControlled:
		# playerGameData.velocity should be updated by gravity if it is controlled by player
		actor.velocity.y += actor.gravity * delta
	else:
		# playerGameData.velocity should be updated by server info if not controlled by player
		actor.velocity.y = actor.playerGameData.velocity.y
	
	actor._flip_sprite()
	actor.move_and_slide()
	
	# Play the idle animation
	if actor.playerGameData.velocity.x == 0:
		actor.animation_player.play("idle")
	
	# Switch to other states if suitable
	if player_health_component.current_health == 0:
		Transitioned.emit(self, "hypolitadeath")
	# -- Switch using Input if controlled
	if actor.playerGameData.isControlled:
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
			Transitioned.emit(self, "hypolitarun")
		
		# transitions to jump state
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "hypolitajump")
		
		# transitions to attack state
		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "hypolitaattack")
		
		# transitions to skill state
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "hypolitaskill")
	# -- Switch using variables if not controlled
	else:
		if actor.playerGameData.velocity.x != 0:
			Transitioned.emit(self, "hypolitarrun")
		
		# transitions to jump state
		if actor.playerGameData.isJumping:
			Transitioned.emit(self, "hypolitajump")
		
		# transitions to attack state
		if actor.playerGameData.isAttacking:
			Transitioned.emit(self, "hypolitaattack")
		
		# transitions to skill state
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "hypolitaskill")


func _on_timer_timeout():
	idle.play()
	
	delay_timer.start()
