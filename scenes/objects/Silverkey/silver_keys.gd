extends Node2D

var key_taken : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		key_taken = true
		visible = false
		# add notif
		EventNotifier.add_notif("You got a silver key")
		Dialogic.start("S2_2-6")
