class_name PlayerRun
extends State

# references & variables
@export var actor : CharacterBody2D
@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"


func enter() -> void:
	print("Entered Run State")

func update(delta: float) -> void:
	if actor.velocity.x != 0:
		actor.animation_player.play("run")

func physics_update(delta: float) -> void:
	# character movement
	actor.velocity.y += actor.gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	
	
	actor.velocity.x = movement
	actor.move_and_slide()
	
	# transitions to idle state
	if actor.velocity.x == 0:
		Transitioned.emit(self, "playeridle")
	
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
	# flip sprite
	actor.flip_sprite()
	
