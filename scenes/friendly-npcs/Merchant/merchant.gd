class_name Merchant
extends CharacterBody2D

@export var silver_key: Node2D
@onready var interaction_area: InteractionArea = $InteractionArea

var talked : bool = false

func _ready() -> void:
	silver_key.visible = false
	interaction_area.interact = Callable(self, "on_talk")

func on_talk() -> void:
	if !talked:
		Dialogic.start("S2_2-5")
		await Dialogic.timeline_ended
		silver_key.visible = true
		talked = true
