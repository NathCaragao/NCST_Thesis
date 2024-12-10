# key.gd
extends Area2D

var key_taken : bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if key_taken == false:
			EventNotifier.add_notif("You got a totem")
			key_taken = true
			visible = false
