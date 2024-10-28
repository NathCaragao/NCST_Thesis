extends Area2D

var key : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		key = true
		queue_free()
