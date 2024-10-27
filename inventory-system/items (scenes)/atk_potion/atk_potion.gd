extends Node2D


@export var item : InventoryItem
@onready var player = get_tree().get_first_node_in_group("Player")




func _on_area_2d_body_entered(body: Node2D) -> void:
	if player:
		player.collect(item)
		queue_free()
