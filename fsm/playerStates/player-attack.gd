class_name PlayerAttack
extends State

# references
@export var actor : CharacterBody2D
@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"

# variables
var attack_index : int = 0
var attack_animations : Array = ["attack1", "attack2"]
var is_attacking : bool = false

# projectie references
@onready var arrow = load("res://scenes/mechanisms/arrow/arrow.tscn") as PackedScene
var bow_cooldown : bool = true
@onready var level_1 = get_tree().get_first_node_in_group("Levels")

var attackCooldown = 0.5


func _ready() -> void:
	pass


func enter() -> void:
	if actor.playerGameData.weaponMode == "Melee":
		sword_attack()
	elif actor.playerGameData.weaponMode == "Ranged":
		bow_attack()

func update(delta: float) -> void:
	pass

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
	
	actor.playerGameData.isAttacking = false
	if actor.playerGameData.isControlled:
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			Transitioned.emit(self, "playerrun")
		# transitions to jump state
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "playerjump")
		
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "playerskill")
	else:
		if actor.playerGameData.velocity.x != 0:
			Transitioned.emit(self, "playerrun")
		# transitions to jump state
		if actor.playerGameData.isJumping:
			Transitioned.emit(self, "playerjump")
		
		if actor.playerGameData.isSkill:
			Transitioned.emit(self, "playerskill")
	
	if player_health_component.current_health == 0:
		Transitioned.emit(self, "playerdeath")
		
	Transitioned.emit(self, "playeridle")
	

func _physics_process(delta: float) -> void:
	pass

func process_input(event: InputEvent) -> void:
	pass
	# Prevent transitioning out of the attack state while attacking
		# transitions to run state
		#if actor.playerGameData.isControlled:
			#if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				#Transitioned.emit(self, "playerrun")
			## transitions to jump state
			#if Input.is_action_just_pressed("jump"):
				#Transitioned.emit(self, "playerjump")
			#
			#if Input.is_action_just_pressed("skill"):
				#Transitioned.emit(self, "playerskill")
		#else:
			#if actor.playerGameData.velocity.x != 0:
				#Transitioned.emit(self, "playerrun")
			## transitions to jump state
			#if actor.playerGameData.isJumping:
				#Transitioned.emit(self, "playerjump")
			#
			#if actor.playerGameData.isSkill:
				#Transitioned.emit(self, "playerskill")
		#
		#if player_health_component.current_health == 0:
			#Transitioned.emit(self, "playerdeath")


func play_next_attack_animation():
	# Cycle between attack animations
	actor.animation_player.play(attack_animations[attack_index])
	attack_index = (attack_index + 1) % attack_animations.size()

# Handle what happens when an attack animation finishes
func _on_animation_finished(animation_name: String) -> void:
	print_debug(animation_name)
	actor.animation_player.play("idle")
	if animation_name == "attack1" or animation_name == "attack2":
		attackCooldown = float(10.0/60.0)
	elif animation_name == "player-shoot":
		attackCooldown = float(10.0/60.0)
	# Check if the finished animation is an attack animation
	
	#if animation_name in attack_animations or animation_name == "player-shoot":
		#print_debug("I AM THE REASON THAT SHET ISNT BEING REACHED!")
		 ## Continue attacking if the attack button is held
		#if (Input.is_action_just_pressed("attack") and actor.playerGameData.isControlled) or (actor.playerGameData.isAttacking and !actor.playerGameData.isControlled):
			#if actor.playerGameData.weaponMode == "Melee":
				#play_next_attack_animation()
			#elif actor.playerGameData.weaponMode == "Ranged":
				#bow_attack()
		#else:
			## If no attack input, stop the attack and transition to idle or other states
			##if actor.playerGameData.isControlled:
			##actor.playerGameData.isAttacking = false
			#Transitioned.emit(self, "playeridle")  # Transition to idle state after attack

# Melee mode attack
func sword_attack() -> void:
	print("Entered sword_attack state")
	#if actor.playerGameData.isControlled:
		#actor.playerGameData.isAttacking = false
	play_next_attack_animation()
	# Connect the signal for when the attack animation finishes
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))

# Ranged mode attack
func bow_attack() -> void:
	print("Entered bow_attack state")
	actor.velocity.x = 0
	actor.animation_player.play("player-shoot")
	#if actor.playerGameData.isControlled:
		#actor.playerGameData.isAttacking = true
	# Connect the signal for when the attack animation finishes
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))
	
	arrow_fire()

# bow projectile
func arrow_fire() -> void:
	#bow_cooldown = false
	
	var arrow_instance = arrow.instantiate()
	arrow_instance.global_position.x = $"../../ArrowPos/ArrowSpawn".global_position.x + (40 * actor.playerGameData.direction)
	arrow_instance.global_position.y = $"../../ArrowPos/ArrowSpawn".global_position.y
	arrow_instance.vel = $"../../ArrowPos".scale.x
	get_parent().add_child(arrow_instance)


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
