extends Node2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var checkpoint_bool : Node2D

func enable_fire() -> void:
	if checkpoint_bool.checkpoint_reached:
		animated_sprite.play("checkpoint_activate")
