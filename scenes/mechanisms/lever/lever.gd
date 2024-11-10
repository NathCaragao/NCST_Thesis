extends Node2D

@export var interaction_area : InteractionArea
@onready var lever_off: Sprite2D = $LeverOff
@onready var lever_on: Sprite2D = $LeverOn

var lever_activated : bool = false
signal Activate

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_activate")

func activate() -> void:
	lever_off.visible = false
	lever_on.visible = true
	lever_activated = true
	emit_signal("Activate")

func on_activate() -> void:
	activate()
