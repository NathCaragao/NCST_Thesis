class_name HealthPotion
extends Node2D


@export var item : InventoryItem
@onready var player = get_tree().get_first_node_in_group("Player")
@export var heal_amount : int = 50

func _on_area_2d_body_entered(body: Node2D) -> void:
	if player:
		print("collided")
		player.collect(item)
		queue_free()
