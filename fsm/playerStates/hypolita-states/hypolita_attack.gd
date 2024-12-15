class_name HypolitaAttack
extends State

# references
@export var actor : CharacterBody2D
@export var player_health_component: PlayerHpComp

var attack_index : int = 0
var attack_animations : Array = ["attack"]
var is_attacking : bool = false
var attackCooldown = 0.5

func enter() -> void:
	actor.animation_player("attack")

func physics_update(delta: float) -> void:
	# Keep the player as isAttacking true during the animation
	
	var movement
	if actor.playerGameData.isControlled:
		actor.velocity.y += actor.gravity * delta
		movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	else:
		actor.velocity.y = actor.playerGameData.velocity.y
		movement = actor.playerGameData.velocity.x
	
	if !actor.animation_player.current_animation.begins_with("player-shoot"):
		actor.velocity.x = movement
	actor._flip_sprite()
	actor.move_and_slide()
	
	# While animation is playing, set isAttacking of Player to true and keep player from switching to other states
	if actor.animation_player.is_playing() and (actor.animation_player.current_animation.begins_with("attack") or actor.animation_player.current_animation.begins_with("player-shoot")):
		actor.playerGameData.isAttacking = true
		return
	
	# When attack anim finishes, lock the player in attack state to prevent atk anim spam
	if attackCooldown > 0:
		actor.playerGameData.isAttacking = false
		attackCooldown -= delta
		return
	
	if actor.playerGameData.isControlled:
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			Transitioned.emit(self, "hypolitarun")
		# transitions to jump state
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "hypolitajump")
		
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "hypolitaskill")
	else:
		if actor.playerGameData.velocity.x != 0:
			Transitioned.emit(self, "hypolitarun")
		# transitions to jump state
		if actor.playerGameData.isJumping:
			Transitioned.emit(self, "hypolitajump")
		
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "hypolitaskill")
	
	if player_health_component.current_health == 0:
		Transitioned.emit(self, "hypolitadeath")
		
	Transitioned.emit(self, "hypolitaidle")

func play_next_attack_animation():
	# Cycle between attack animations
	actor.animation_player.play(attack_animations[attack_index])
	attack_index = (attack_index + 1) % attack_animations.size()

# Handle what happens when an attack animation finishes
func _on_animation_finished(animation_name: String) -> void:
	actor.animation_player.play("idle")
	if animation_name == "attack1" or animation_name == "attack2":
		attackCooldown = float(10.0/60.0)
	elif animation_name == "player-shoot":
		attackCooldown = float(10.0/60.0)

# Melee mode attack
func sword_attack() -> void:
	print("Entered sword_attack state")
	#if actor.playerGameData.isControlled:
		#actor.playerGameData.isAttacking = false
	play_next_attack_animation()
	# Connect the signal for when the attack animation finishes
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))

func exit() -> void:
	actor.velocity = Vector2.ZERO
	# Disconnect the signal when exiting the attack state
	actor.animation_player.animation_finished.disconnect(_on_animation_finished)

func update_animation(movement):
	if actor.animation_player.current_animation.begins_with("attack") or actor.animation_player.current_animation.begins_with("player-shoot"):
		if not actor.animation_player.is_playing():
			actor.animation_player.stop()
		else:
			return
