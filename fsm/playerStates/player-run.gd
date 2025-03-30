class_name PlayerRun
extends State

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
	var movement
	if actor.playerGameData.isControlled:
		actor.velocity.y += actor.gravity * delta
		movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	else:
		actor.velocity.y = actor.playerGameData.velocity.y
		movement = actor.playerGameData.velocity.x

	actor.velocity.x = movement

	if actor.velocity.x != 0 and not is_running_audio_playing:
		RunForrestRun.play()
		is_running_audio_playing = true
	elif actor.velocity.x == 0 and is_running_audio_playing:
		RunForrestRun.stop()
		is_running_audio_playing = false

	actor._flip_sprite()
	actor.move_and_slide()

	if actor.velocity.x == 0:
		Transitioned.emit(self, "playeridle")
	if actor.playerGameData.isControlled:		
		if Input.is_action_just_pressed("jump"):
			RunForrestRun.stop()
			is_running_audio_playing = false
			Transitioned.emit(self, "playerjump")

		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "playerattack")
		
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "playerskill")

	else:
		if actor.playerGameData.isJumping:
			RunForrestRun.stop()
			is_running_audio_playing = false
			Transitioned.emit(self, "playerjump")
		
		if actor.playerGameData.isAttacking:
			Transitioned.emit(self, "playerattack")
		
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "playerskill")	

	if player_hp.current_health == 0:
		RunForrestRun.stop()
		is_running_audio_playing = false
		Transitioned.emit(self, "playerdeath")
