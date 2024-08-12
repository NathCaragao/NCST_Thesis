extends Area2D

@onready var anim = $AnimationPlayer

@export var item: InventoryItem
var player = null
@onready var chest1 = $"../../Chests/Chest"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player.collect(item)
		anim.play("aegis_pickup")
