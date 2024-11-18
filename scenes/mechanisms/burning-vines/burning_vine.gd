extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var divine_torch : Area2D
@onready var interaction_area: InteractionArea = $InteractionArea
@export var torch_item: AnimatedSprite2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_use_torch")

func on_use_torch() -> void:
	if divine_torch.torch_taken == true:
		await animation_player.animation_finished
		animation_player.play("vine-burn")
		divine_torch.torch_unequipped()
		divine_torch.torch_taken = false
	
	elif torch_item and !torch_item.visible:
		Dialogic.start("burn_vines_false")
