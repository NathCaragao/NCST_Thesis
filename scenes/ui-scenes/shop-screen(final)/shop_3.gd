extends Control

@export var stat_window : Control
@export var skin_window : Control


func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()


func _on_stats_section_pressed() -> void:
	skin_window.visible = false
	stat_window.visible = true




func _on_skins_section_pressed() -> void:
	stat_window.visible = false
	skin_window.visible = true



func _on_gems_section_pressed() -> void:
	pass
