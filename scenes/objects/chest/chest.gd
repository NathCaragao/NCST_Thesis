extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")

func open() -> void:
	$Closed.visible = false
	$Opened.visible = true
	$"../CommonGear".visible = true

func close() -> void:
	$Opened.visible = false
	$Closed.visible = true

func on_interact() -> void:
	open()
