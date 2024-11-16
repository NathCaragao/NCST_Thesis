extends Node

@export var initial_state : State

var current_state : State

# dictionary for states
var states : Dictionary = {}

func _ready() -> void:
	# Gather all child states and connect their Transitioned signals
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	# Set the initial state
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

# Handles state transition
func on_child_transition(state, new_state_name):
	# Only proceed if the transition is from the current state
	if state != current_state:
		return
	
	# Look up the new state from the dictionary
	var new_state = states.get(new_state_name.to_lower())
	if new_state:
		# Properly transition to the new state
		if current_state:
			current_state.exit()
		
		new_state.enter()
		current_state = new_state
