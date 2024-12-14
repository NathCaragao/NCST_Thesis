extends Control

@onready var pause_btn: Button = $PauseBtn
@onready var video_player: VideoStreamPlayer = $AspectRatioContainer/VideoStreamPlayer

func _on_close_btn_pressed() -> void:
	close_tween_anim()

func close_tween_anim() -> void:
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

func _on_pause_play_btn_pressed() -> void:
	video_player.paused = !video_player.paused
	if video_player.paused:
		pause_btn.text = "Play"
	else:
		pause_btn.text = "Pause"
