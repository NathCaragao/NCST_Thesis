class_name PlayerSkill
extends State

# references
@export var actor : CharacterBody2D
@export var player_health_component: PlayerHpComp
@onready var arrow = load("res://scenes/mechanisms/arrow/arrow.tscn") as PackedScene

var skillCooldown: float = 0.0

func enter() -> void:
	if !(skillCooldown > 0):
		actor.velocity.x = 0 # Makes the player be stuck in place before doing skill attack
		skill_activate()

func _physics_process(delta: float) -> void:
	if actor.animation_player.current_animation.begins_with("player-shoot"):
		return
		
	if skillCooldown > 0:
		skillCooldown -= delta
	elif skillCooldown <= 0:
		skillCooldown = 0.0

func physics_update(delta: float) -> void:
	actor.velocity.y += actor.gravity * delta
	actor._flip_sprite()
	
	if skillCooldown > 0:
		actor.playerGameData.isSkill = false
		Transitioned.emit(self, "playeridle")
	
	if actor.animation_player.is_playing() and actor.animation_player.current_animation.begins_with("player-shoot"):
		actor.playerGameData.isSkill = true
	
	if not actor.animation_player.is_playing():
		actor.playerGameData.isSkill = false
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
	#actor.animation_player.play("player-shoot")
	bow_attack()
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))
		
		
func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "player-shoot":
		skillCooldown = 3.0
		
	if actor.animation_player.current_animation.begins_with("player-shoot"):
		if not actor.animation_player.is_playing():
			actor.animation_player.stop()
			
	# Disconnect the signal when exiting the skill state
	actor.velocity = Vector2.ZERO
	actor.animation_player.animation_finished.disconnect(_on_animation_finished)


func bow_attack():
	actor.velocity.x = 0
	actor.animation_player.play("player-shoot")
	#if actor.playerGameData.isControlled:
		#actor.playerGameData.isAttacking = true
	# Connect the signal for when the attack animation finishes
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))
	arrow_fire()
	
func arrow_fire():
	var arrow_instance = arrow.instantiate()
	arrow_instance.global_position.x = $"../../ArrowPos/ArrowSpawn".global_position.x + (40 * actor.playerGameData.direction)
	arrow_instance.global_position.y = $"../../ArrowPos/ArrowSpawn".global_position.y
	arrow_instance.vel = $"../../ArrowPos".scale.x
	get_parent().add_child(arrow_instance)
