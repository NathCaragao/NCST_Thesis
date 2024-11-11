extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var divine_torch : Area2D
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var torch_item: AnimatedSprite2D = $"../Player/TorchItem"

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_use_torch")

func on_use_torch() -> void:
	if divine_torch.torch_taken == true:
		animation_player.play("vine-burn")
		divine_torch.torch_unequipped()
		divine_torch.torch_taken = false
	elif torch_item and !torch_item.visible:
		print("Divine Torch is required to burn this vine!")
