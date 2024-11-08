extends Node2D

@export var player : PlayerHercules
@export var fail_screen: Control

func _ready() -> void:
	player.connect("PlayerDead", Callable(self, "on_player_dead"))


func on_player_dead() -> void:
	fail_screen.visible = true
