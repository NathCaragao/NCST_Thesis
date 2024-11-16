class_name State
extends Node

# signal for transitioning state
signal Transitioned

# enter the state
func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
