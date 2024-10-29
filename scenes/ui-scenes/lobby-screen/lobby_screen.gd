# lobby screen.gd
extends Node2D

# references
@export var settings_window : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	settings_window.visible = !settings_window.visible
