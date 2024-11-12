extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var lever : Node2D

func _ready() -> void:
	lever.connect("Activate", Callable(self, "on_activate"))

func on_activate() -> void:
	animation_player.play("gate-lvl3-open")
	print("Gate Opening!!")
