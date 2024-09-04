extends State

@export var fall_state : State
@export var run_state : State
@export var jump_state : State
@export var attack_state : State
@export var skill_state : State

@onready var state_label: Label = $"../../StateLabel"


func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.animation_player.play("idle")
	state_label.text = "Current State: Idle"

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("attack"):
		return attack_state
	if Input.is_action_just_pressed("skill"):
		return skill_state
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		return run_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
