class_name HydraAttack
extends State

# references
@export var actor : CharacterBody2D

func enter() -> void:
	actor.play_animation("enemy-attack")
