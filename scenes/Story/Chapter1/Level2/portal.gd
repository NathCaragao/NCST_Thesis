extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@export var actor : PlayerHercules

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_portal_enter")

func on_portal_enter() -> void:
	actor.position.x = 7079
	actor.position.y = 3099
	print("teleported")
