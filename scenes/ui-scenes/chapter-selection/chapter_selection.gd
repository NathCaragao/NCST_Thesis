# chapter_selection.gd
extends Control

@export var level_selection_window : Control
@export var greek_levels_window : Control

# chapter 1 button
func _on_ch_btn_pressed() -> void:
	level_selection_open()

# back button
func _on_back_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/game-mode-screen/game_mode_screen.tscn")


func _on_multiplayer_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/multiplayerLevelManager/MultiplayerLevelManager.tscn")

func level_selection_open() -> void:
	level_selection_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	level_selection_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(level_selection_window, "position:y", screen_size.y / 2 - level_selection_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)


func _on_ch_btn_2_pressed() -> void:
	greek_tales_level_open()

func greek_tales_level_open() -> void:
	greek_levels_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	greek_levels_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(greek_levels_window, "position:y", screen_size.y / 2 - greek_levels_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)
