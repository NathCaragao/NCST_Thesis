extends Control

var total_rotation: float = 0

func rotate_roulette(spin: int) -> void:
	var tween = create_tween()
	total_rotation += deg_to_rad(spin)
	
	tween.tween_property($Roulette, "rotation", total_rotation, 0.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
