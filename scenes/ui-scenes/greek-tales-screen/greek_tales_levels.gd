extends Control

@export_category("Level Paths")
@export var atalanta_level : String
@export var hypolita_level : String

# close the window
func close_window() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Get the screen size
	var screen_size = get_viewport_rect().size
	
	# Animate the window moving from center to bottom
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)



func _on_atalanta_play_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(atalanta_level)




func _on_hypolita_plat_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(hypolita_level)
