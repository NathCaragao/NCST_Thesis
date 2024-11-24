class_name PlayerRun
extends State

# references & variables
@export var actor : CharacterBody2D
@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"


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
	actor._flip_sprite()
	actor.move_and_slide()
	
	# Switch to other states if suitable
	# transitions to idle state
	if actor.velocity.x == 0:
		Transitioned.emit(self, "playeridle")
	# -- Switch using Input if controlled
	if actor.playerGameData.isControlled:		
		# transitions to jump state
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "playerjump")
		
		# transitions to attack state
		if Input.is_action_just_pressed("attack"):
			Transitioned.emit(self, "playerattack")
		
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "playerskill")
		
		if player_health_component.current_health == 0:
			Transitioned.emit(self, "playerdeath")
	else:
		# -- Switch if not controlled
		if actor.playerGameData.isJumping:
			Transitioned.emit(self, "playerjump")
		
		# transitions to attack state
		if actor.playerGameData.isAttacking:
			Transitioned.emit(self, "playerattack")
		
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "playerskill")
		
		if player_health_component.current_health == 0:
			Transitioned.emit(self, "playerdeath")
	
