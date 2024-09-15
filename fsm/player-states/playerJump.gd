extends State

@export var fall_state : State
@export var run_state : State
@export var idle_state : State
@export var attack_state : State
@export var skill_state : State

@export var jump_force : float = 700.0  # Same force for both jumps
@export var jump_force2 : float = 400.0
@onready var state_label: Label = $"../../StateLabel"

var jump_count : int = 0; # for double jump


func enter() -> void:
	super()
	# Perform the initial jump
	parent.velocity.y = -jump_force
	parent.animation_player.play("jump")
	state_label.text = "Current State: Jump"


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('attack'):
		return attack_state
	elif Input.is_action_just_pressed("skill"):
		return skill_state
	elif Input.is_action_just_pressed("jump") and jump_count < 1:
		# Allow the double jump if the player hasn't double jumped yet
		parent.velocity.y = -jump_force2
		jump_count += 1
		parent.animation_player.play("jump")
		state_label.text = "Current State: Double Jump"
		return null  # Stay in the current state
	return null


func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement != 0:
		parent.sprite.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return run_state
		return idle_state
	
	return null

func exit() -> void:
	jump_count = 0
