extends Control

@export_group("Level Paths")
@export var level_1_path: String
@export var level_2_path: String
@export var level_3_path: String
@export var level_4_path: String
@export var level_5_path: String
@export var level_6_path: String
@export var level_7_path: String
@export var level_8_path: String
@export var level_9_path: String
@export var level_10_path: String
@export var level_11_path: String
@export var level_12_path: String

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
	
	# After the animation completes, hide the window
	tween.tween_callback(func(): visible = false)

func level_1() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_1_path)

func level_2() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_2_path)

func level_3() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_3_path)

func level_4() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_4_path)

func level_5() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_5_path)

func level_6() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_6_path)

func level_7() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_7_path)

func level_8() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_8_path)

func level_9() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_9_path)

func level_10() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_10_path)

func level_11() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_11_path)

func level_12() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene(level_12_path)
