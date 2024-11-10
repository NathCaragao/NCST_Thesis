extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@export var actor : PlayerHercules

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_portal_exit")


func on_portal_exit() -> void:
	actor.position.x = 2150
	actor.position.y = 211
