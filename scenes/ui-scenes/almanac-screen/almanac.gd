extends Control


@onready var heroes_section: ColorRect = $HeroesSection
@onready var hercules_prof: ColorRect = $HerculesProf


func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()

# close_btn
func almanac_close() -> void:
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


func _on_heroes_btn_pressed() -> void:
	heroes_section.visible = true


func _on_hercules_btn_pressed() -> void:
	# hide other windows
	#heroes_section.visible = false
	# show active window
	hercules_prof.visible = true

# heroes section back button
func _on_hs_backbtn_pressed() -> void:
	heroes_section.visible = false

# hercules profile back btn
func _on_hercules_back_btn_pressed() -> void:
	hercules_prof.visible = false
