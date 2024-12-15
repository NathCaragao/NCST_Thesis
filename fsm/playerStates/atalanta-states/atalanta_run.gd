class_name AtalantaRun
extends State

# references & variables
@export var actor : CharacterBody2D
@export var player_hp: PlayerHpComp
@export var RunForrestRun: AudioStreamPlayer2D

var is_running_audio_playing = false

func enter() -> void:
	print("Entered Run State")

func update(delta: float) -> void:
	if actor.playerGameData.velocity.x != 0:
		actor.animation_player.play("run")

func physics_update(delta: float) -> void:
	# Adjust velocity y(gravity) and velocity x(horizontal movement)
	var movement
	if actor.playerGameData.isControlled:
		actor.velocity.y += actor.gravity * delta
		movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	else:
		actor.velocity.y = actor.playerGameData.velocity.y
		movement = actor.playerGameData.velocity.x

	actor.velocity.x = movement
	
	# Play running sound if the player is moving and the sound isn't already playing
	if actor.velocity.x != 0 and not is_running_audio_playing:
		RunForrestRun.play()
		is_running_audio_playing = true
	elif actor.velocity.x == 0 and is_running_audio_playing:
		# Stop the running sound if the player stops moving
		RunForrestRun.stop()
		is_running_audio_playing = false
		
	actor._flip_sprite()
	actor.move_and_slide()
	
	
	# Switch to other states if suitable
	# transitions to idle state
	if actor.velocity.x == 0:
		Transitioned.emit(self, "atalantaidle")
	# -- Switch using Input if controlled
	if actor.playerGameData.isControlled:		
		# transitions to jump state
		if Input.is_action_just_pressed("jump"):
			RunForrestRun.stop()
			is_running_audio_playing = false
			Transitioned.emit(self, "atalantajump")

		# transitions to attack state
		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "atalantaattack")
		
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "atalantaskill")

	else:
		# -- Switch if not controlled
		if actor.playerGameData.isJumping:
			RunForrestRun.stop()
			is_running_audio_playing = false
			Transitioned.emit(self, "atalantajump")
		
		# transitions to attack state
		if actor.playerGameData.isAttacking:
			Transitioned.emit(self, "atalantaattack")
		
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "atalantaskill")	

	if player_hp.current_health == 0:
		RunForrestRun.stop()
		is_running_audio_playing = false
		Transitioned.emit(self, "atalantadeath")
