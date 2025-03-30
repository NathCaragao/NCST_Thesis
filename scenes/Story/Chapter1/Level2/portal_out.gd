extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@export var actor : PlayerHercules

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_portal_exit")


func on_portal_exit() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	actor.position.x = 2150
	actor.position.y = 211
	Dialogic.start("S2_2-16")
