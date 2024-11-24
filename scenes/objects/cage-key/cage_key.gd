extends Node2D

var cage_key_taken: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		visible = false
		cage_key_taken = true
		print("Cage Key got!")
