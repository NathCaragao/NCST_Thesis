extends Node2D

@export var animation_player : AnimationPlayer


func open() -> void:
	animation_player.play("stone-gate-open")
