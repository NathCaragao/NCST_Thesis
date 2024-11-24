extends Node2D

@onready var closed: Sprite2D = $Closed
@onready var open: Sprite2D = $Open
@onready var interaction_area: InteractionArea = $InteractionArea
@export var cage_key: Node2D
@export var divine_torch : Area2D


func _ready() -> void:
	interaction_area.interact = Callable(self, "on_cage_open")
	close_cage()

func open_cage() -> void:
	closed.visible = false
	open.visible = true
	print("The cage is open")

func close_cage() -> void:
	closed.visible = true
	open.visible = false

func on_cage_open() -> void:
	if cage_key.cage_key_taken == true:
		divine_torch.unlocked = true
		open_cage()
	else:
		print("A cage key is required to open the cage")
