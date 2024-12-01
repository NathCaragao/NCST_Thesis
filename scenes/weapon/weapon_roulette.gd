extends Control

#var melee_mode: bool = true
var total_rotation: float = 0

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("toggle_mode"):
		#melee_mode = !melee_mode
		#rotate_roulette()

func rotate_roulette(spin: int) -> void:
	# Create a new Tween node
	var tween = create_tween()
	
	# Always rotate 180 degrees in the same direction
	total_rotation += deg_to_rad(spin)
	
	# Configure the tween for a spinning rotation
	tween.tween_property($Roulette, "rotation", total_rotation, 0.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
