extends State

@export var idle_state : State
@export var run_state : State

@onready var state_label: Label = $"../../StateLabel"

func enter() -> void:
	parent.velocity = Vector2.ZERO
	parent.animation_player.play("skill01")
	state_label.text = "Current State: Skill01"


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		return run_state
	return null

func process_physics(delta: float) -> State:
	if not parent.animation_player.is_playing():
		# Animation ended, decide what to do next
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			return run_state
		else:
			return idle_state
	return null

func exit() -> void:
	parent.velocity = Vector2.ZERO
