# lobby screen.gd
extends Node2D

# references
@export var settings_window : Control
@export var almanac_window : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# shop button
func _on_shop_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/shop-screen/shop.tscn")

# play button
func _on_play_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/chapter-selection/chapter_selection.tscn")

# settings button
func _on_settings_btn_pressed() -> void:
	# press to open and close
	settings_open()

func _on_alamanac_btn_pressed() -> void:
	almanac_open()

func almanac_open() -> void:
	almanac_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	almanac_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(almanac_window, "position:y", screen_size.y / 2 - almanac_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)

func settings_open() -> void:
	settings_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	settings_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(settings_window, "position:y", screen_size.y / 2 - settings_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
