extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@export var actor : PlayerHercules
@export var silver_key1 : Node2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_portal_enter")

func on_portal_enter() -> void:
	if silver_key1.key_taken == true:
		# in-game screen fade out transition
		LevelScreenTransition.transition()
		await LevelScreenTransition.on_transition_finished
		
		# teleport the player into the specified position
		actor.position.x = 7079
		actor.position.y = 3099
		print("teleported")
		Dialogic.start("S2_2-7")
	else:
		print("Key is required")
