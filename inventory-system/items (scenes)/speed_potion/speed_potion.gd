class_name SpeedPotion
extends Node2D


@export var item : InventoryItem
@onready var player = get_tree().get_first_node_in_group("Player")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if player:
		print("collided")
		player.collect(item)
		EventNotifier.add_notif("You got Speed Potion")
		queue_free()


func _on_timer_timeout() -> void:
	pass # Replace with function body.
