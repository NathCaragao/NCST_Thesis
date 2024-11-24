extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var divine_torch: Area2D
@onready var interaction_area: InteractionArea = $InteractionArea
@export var torch_item: AnimatedSprite2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_use_torch")

func on_use_torch() -> void:
	print("Torch taken:", str(divine_torch.torch_taken))
	if divine_torch.torch_taken:
		burn_vines()
	else:
		Dialogic.start("burn_vines_false")

func burn_vines() -> void:
	# enters dialog
	Dialogic.start("use_apollo_flame")
	await Dialogic.timeline_ended # waits for the dialog to finish
	
	# play animation
	animation_player.play("vine-burn")
	await animation_player.animation_finished # waits for the animation above to finish
	divine_torch.torch_unequipped()
	
	Dialogic.start("use_apollo_flame_2")
	await Dialogic.timeline_ended
	
	print("Currently Buring VINES!!!")
