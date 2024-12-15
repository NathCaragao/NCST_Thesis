class_name HypolitaJump
extends State

# variables and references
@export var actor : CharacterBody2D
@export var jump_force : float = -450.0  # Negative for upwards
@export var jump_force2 : float = -350.0 # for double jump
@export var player_health_component: PlayerHpComp

# double jump count variable
var jump_count : int = 0

func enter() -> void:
	print("Entered Jump State")
	actor.velocity.y = jump_force  # Apply the jump force
	actor.animation_player.play("jump")  # Play jump animation

func physics_update(delta: float) -> void:
	if ((Input.is_action_just_pressed("jump") and actor.playerGameData.isControlled) or
	(actor.playerGameData.isJumping and !actor.playerGameData.isControlled)) and jump_count < 1:
		# Allow the double jump if the player hasn't double jumped yet
		actor.velocity.y = jump_force2
		print("Entered double jump state")
		jump_count += 1

	var movement
	if actor.playerGameData.isControlled:
		actor.velocity.y += actor.gravity * delta
		movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	else:
		actor.velocity.y = actor.playerGameData.velocity.y
		movement = actor.playerGameData.velocity.x

	actor.velocity.x = movement
	actor.move_and_slide()
	
	# Transition to fall if the player is falling down
	if actor.velocity.y > 0:
		Transitioned.emit(self, "hypolitafall")

	if actor.playerGameData.isControlled:
	# transitions to attack state
		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "hypolitaattack")
	else:
		if actor.playerGameData.isAttacking:
			Transitioned.emit(self, "hypolitaattack")
	# If player lands, transition to idle or run
	if actor.is_on_floor():
		if movement != 0:
			Transitioned.emit(self, "hypolitarun")
		else:
			Transitioned.emit(self, "hypolitaidle")


func on_player_dead3() -> void:
	Transitioned.emit(self, "hypolitadeath")
	
# resets the jump count to 0
func exit() -> void:
	jump_count = 0
