# key.gd
extends Area2D

var key_taken : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if key_taken == false:
			print("got a key!")
			key_taken = true
			hide()
