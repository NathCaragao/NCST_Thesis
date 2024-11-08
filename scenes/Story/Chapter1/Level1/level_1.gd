extends Node2D

@export var player : PlayerHercules
@export var fail_screen: Control

func _ready() -> void:
	player.connect("PlayerFail", Callable(self, "on_player_fail"))


func on_player_fail() -> void:
	fail_screen.open()
