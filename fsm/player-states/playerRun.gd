extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var attack_state: State
@export var skill_state : State


@onready var state_label: Label = $"../../StateLabel"

func enter() -> void:
	state_label.text = "Current State: Run"

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("attack"):
		return attack_state
	elif Input.is_action_just_pressed("skill"):
		return skill_state
	elif Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis('move_left', 'move_right') * move_speed
	
	if movement == 0:
		return idle_state
	
	parent.animation_player.play("run")
	parent.sprite.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
