extends Node2D

@export var fail_screen: Control
@export var pause_screen : Control
@export var victory_screen : Control
@export var actor : PlayerHercules
var paused : bool = false

func _ready() -> void:
	pass

# when player dies: fail screen opens
func on_player_fail() -> void:
	fail_screen.open()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_screen.open()
		get_tree().paused = true

# teleport activation
func _on_teleport_body_entered(body: Node2D) -> void:
	call_deferred("player_teleport")

func player_teleport() -> void:
	# in-game screen fade out transition
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	# teleport the player to the specified position
	actor.position.x = 2635
	actor.position.y = 4685
