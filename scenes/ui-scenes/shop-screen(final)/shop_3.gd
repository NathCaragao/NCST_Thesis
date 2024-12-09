extends Control

@export var stat_window : Control
@export var skin_window : Control
@export var gems_window : Control
@onready var tab_title: Label = $TabTitle



func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()


func _on_stats_section_pressed() -> void:
	tab_title.text = "STATS"
	skin_window.visible = false
	gems_window.visible = false
	stat_window.visible = true




func _on_skins_section_pressed() -> void:
	tab_title.text = "SKINS"
	stat_window.visible = false
	gems_window.visible = false
	skin_window.visible = true



func _on_gems_section_pressed() -> void:
	tab_title.text = "GEMS"
	skin_window.visible = false
	stat_window.visible = false
	gems_window.visible = true
	

func shop_close() -> void:
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


func _on_close_btn_pressed() -> void:
	shop_close()
