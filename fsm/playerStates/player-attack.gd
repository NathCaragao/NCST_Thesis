class_name PlayerAttack
extends State

# references
@export var actor : PlayerHercules
@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"

# variables
var attack_index : int = 0
var attack_animations : Array = ["attack1", "attack2"]
var is_attacking : bool = false

# projectie references
@onready var arrow = load("res://scenes/mechanisms/arrow/arrow.tscn") as PackedScene
var bow_cooldown : bool = true
@onready var level_1 = get_tree().get_first_node_in_group("Levels")


func _ready() -> void:
	pass

func enter() -> void:
	if actor.weapon_mode == "Melee":
		sword_attack()
	elif actor.weapon_mode == "Ranged":
		bow_attack()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# Apply gravity to keep the actor grounded
	actor.velocity.y += actor.gravity * delta
	var movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	
	actor.move_and_slide()
	

func _physics_process(delta: float) -> void:
	pass

func process_input(event: InputEvent) -> void:
	# Prevent transitioning out of the attack state while attacking
		# transitions to run state
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			Transitioned.emit(self, "playerrun")

		# transitions to jump state
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "playerjump")
		
		if Input.is_action_just_pressed("skill"):
			Transitioned.emit(self, "playerskill")
		
		if player_health_component.current_health == 0:
			Transitioned.emit(self, "playerdeath")


func play_next_attack_animation():
	# Cycle between attack animations
	actor.animation_player.play(attack_animations[attack_index])
	attack_index = (attack_index + 1) % attack_animations.size()

# Handle what happens when an attack animation finishes
func _on_animation_finished(animation_name: String) -> void:
	# Check if the finished animation is an attack animation
	if animation_name in attack_animations or animation_name == "player-shoot":
		 # Continue attacking if the attack button is held
		if Input.is_action_just_pressed("attack"):
			if actor.weapon_mode == "Melee":
				play_next_attack_animation()
		
		elif Input.is_action_just_pressed("attack"):
			if actor.weapon_mode == "Ranged":
				bow_attack()
		else:
			# If no attack input, stop the attack and transition to idle or other states
			is_attacking = false
			Transitioned.emit(self, "playeridle")  # Transition to idle state after attack
# Melee mode attack
func sword_attack() -> void:
	print("Entered sword_attack state")
	is_attacking = true
	play_next_attack_animation()
	# Connect the signal for when the attack animation finishes
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))

# Ranged mode attack
func bow_attack() -> void:
	print("Entered bow_attack state")
	actor.animation_player.play("player-shoot")
	is_attacking = true
	# Connect the signal for when the attack animation finishes
	if not actor.animation_player.animation_finished.is_connected(Callable(self, "_on_animation_finished")):
		actor.animation_player.animation_finished.connect(Callable(self, "_on_animation_finished"))
	
	arrow_fire()

# bow projectile
func arrow_fire() -> void:
	#bow_cooldown = false
	
	var arrow_instance = arrow.instantiate()
	arrow_instance.global_position = $"../../ArrowPos/ArrowSpawn".global_position
	arrow_instance.vel = $"../../ArrowPos".scale.x
	level_1.get_parent().add_child(arrow_instance)


func exit() -> void:
	actor.velocity = Vector2.ZERO
	# Disconnect the signal when exiting the attack state
	actor.animation_player.animation_finished.disconnect(_on_animation_finished)

func update_animation(movement):
	if actor.animation_player.current_animation.begins_with("attack"):
		if not actor.animation_player.is_playing():
			actor.animation_player.stop()
		else:
			return
