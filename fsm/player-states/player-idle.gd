class_name PlayerIdle
extends State

# references
@export var actor : PlayerHercules
#@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"

func enter() -> void:
	print("Entered Idle State")

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# putting the gravity to the actor
	actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()
	
	if actor.velocity.x == 0:
		actor.animation_player.play("idle")
	
	# transitions to run state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		Transitioned.emit(self, "playerrun")
	
	# transitions to jump state
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "playerjump")
	
	# transitions to attack state
	if Input.is_action_just_pressed("attack"):
		Transitioned.emit(self, "playerattack")
	
	## transitions to skill state
	#if Input.is_action_just_pressed("skill"):
		#Transitioned.emit(self, "playerskill")
	
	#if player_health_component.current_health == 0:
		#Transitioned.emit(self, "playerdeath")
