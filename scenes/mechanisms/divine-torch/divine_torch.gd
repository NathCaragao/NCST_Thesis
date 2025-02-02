extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var torch_item : AnimatedSprite2D
@export var player : CharacterBody2D
@export var cage: Node2D


var unlocked : bool = false
var torch_taken : bool = false
var cage_key_taken: bool = false

func _process(delta: float) -> void:
	flip_torch_sprite()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
			if unlocked:
				visible = false
				torch_taken = true
				torch_equipped()
				EventNotifier.add_notif("You got Divine Torch!")
				Dialogic.start("S2_2-14_2")

func torch_equipped() -> void:
	torch_item.visible = true

func torch_unequipped() -> void:
	torch_item.visible = false

func flip_torch_sprite() -> void:
	if player.velocity.x > 0:
		torch_item.position.x = 6
	elif player.velocity.x < 0:
		torch_item.position.x = -6
