extends Node2D

@export var gate: Node2D
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_activate")

func on_activate():
	switched_on()
	gate.gate_open()

func switched_on() -> void:
	$LeverOff.visible = false
	$LeverOn.visible = true

func switched_off() -> void:
	$LeverOn.visible = false
	$LeverOff.visible = true
