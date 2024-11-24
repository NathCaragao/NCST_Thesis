extends Node2D

@export var animation_player : AnimationPlayer
@export var lever : Node2D

func _ready() -> void:
	lever.connect("Activate", Callable(self, "on_activate"))

func open() -> void:
	if lever.lever_activated == true:
		animation_player.play("stone-gate-open")
		print("Stone_gate opened!")
	else:
		print("Activate the lever first!")

func on_activate() -> void:
	open()
