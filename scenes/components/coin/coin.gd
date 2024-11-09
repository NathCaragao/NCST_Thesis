# coin.gd
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		ScoreManager.add_points("coin") # adds to the score UI(s)
		print("+ 1")
		queue_free()
