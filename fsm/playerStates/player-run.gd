class_name PlayerRun
extends State

# references & variables
@export var actor: PlayerHercules
@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"
@onready var RunForrestRun: AudioStreamPlayer2D = $"../../player_sound/run"

var is_running_audio_playing = false

func enter() -> void:
	print("Entered Run State")

func update(delta: float) -> void:
	if actor.velocity.x != 0:
		actor.animation_player.play("run")

func physics_update(delta: float) -> void:
	# Apply gravity
	actor.velocity.y += actor.gravity * delta

	# Get horizontal movement input
	var movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	actor.velocity.x = movement
	actor.move_and_slide()

	# Play running sound if the player is moving and the sound isn't already playing
	if actor.velocity.x != 0 and not is_running_audio_playing:
		RunForrestRun.play()
		is_running_audio_playing = true
	elif actor.velocity.x == 0 and is_running_audio_playing:
		# Stop the running sound if the player stops moving
		RunForrestRun.stop()
		is_running_audio_playing = false

	# Transition to idle state
	if actor.velocity.x == 0:
		Transitioned.emit(self, "playeridle")

	# Transition to jump state
	if Input.is_action_just_pressed("jump"):
		RunForrestRun.stop()
		is_running_audio_playing = false
		Transitioned.emit(self, "playerjump")

	# Transition to attack state
	if Input.is_action_just_pressed("attack"):
		Transitioned.emit(self, "playerattack")

	# Transition to skill state
	if Input.is_action_just_pressed("skill"):
		Transitioned.emit(self, "playerskill")

	# Transition to death state if health is zero
	if player_health_component.current_health == 0:
		RunForrestRun.stop()
		is_running_audio_playing = false
		Transitioned.emit(self, "playerdeath")

	# Flip sprite based on movement direction
	actor.flip_sprite()
