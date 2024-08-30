extends State

@export var idle_state : State
@export var run_state : State
@export var skill_state : State

var attack_index: int = 0
var attack_animations: Array = ["attack1", "attack2"]

@onready var state_label: Label = $"../../StateLabel"



func enter() -> void:
	parent.velocity = Vector2.ZERO
	play_next_attack_animation()
	state_label.text = "Current State: Basic ATK"

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

func play_next_attack_animation():
	attack_index = (attack_index + 1) % attack_animations.size()
	parent.animation_player.play(attack_animations[attack_index])

func exit() -> void:
	parent.velocity = Vector2.ZERO
