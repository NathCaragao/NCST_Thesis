extends State

@export
var idle_state: State
@export
var run_state: State
@export var attack_state : State
@export var skill_state : State

@onready var state_label: Label = $"../../StateLabel"


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('attack'):
		return attack_state
	elif Input.is_action_just_pressed("skill"):
		return skill_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.animation_player.play("fall")
	state_label.text = "Current State: Jump"

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
