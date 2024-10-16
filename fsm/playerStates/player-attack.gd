class_name PlayerAttack
extends State

# references
@export var actor : PlayerHercules
@onready var player_health_component: PlayerHpComp = $"../../PlayerHealthComponent"

# variables
var attack_index : int = 0
var attack_animations : Array = ["attack1", "attack2"]

func enter() -> void:
	print("Entered attack state")
	play_next_attack_animation()
	# Connect the signal for when the attack animation finishes
	actor.animation_player.animation_finished.connect(_on_animation_finished)

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	# Apply gravity to keep the actor grounded
	actor.velocity.y += actor.gravity * delta
	var movement = Input.get_axis("move_left", "move_right") * actor.move_speed
	
	actor.move_and_slide()
	

func process_input(event: InputEvent) -> void:
	# Prevent transitioning out of the attack state while attacking
		# transitions to run state
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			Transitioned.emit(self, "playerrun")

		# transitions to jump state
		if Input.is_action_just_pressed("jump"):
			Transitioned.emit(self, "playerjump")
		
		if player_health_component.current_health == 0:
			Transitioned.emit(self, "playerdeath")


func play_next_attack_animation():
	# Cycle between attack animations
	actor.animation_player.play(attack_animations[attack_index])
	attack_index = (attack_index + 1) % attack_animations.size()

# Handle what happens when an attack animation finishes
func _on_animation_finished(animation_name: String) -> void:
	# Check if the finished animation is an attack animation
	if animation_name in attack_animations:
		if Input.is_action_pressed("attack"):
			# If the player is still holding attack, play the next attack
			play_next_attack_animation()
		else:
			# If not attacking anymore, stop attacking and allow transitions
			Transitioned.emit(self, "playeridle")

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
