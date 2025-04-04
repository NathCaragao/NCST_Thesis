extends Control
@onready var pause_play_btn: Button = $PausePlayBtn
@onready var video_player: VideoStreamPlayer = $AspectRatioContainer/VideoStreamPlayer
func _on_close_btn_pressed() -> void:
	close_tween_anim()
func close_tween_anim() -> void:
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): visible = false)
func _on_pause_play_btn_pressed() -> void:
	video_player.paused = !video_player.paused
	if video_player.paused:
		pause_play_btn.text = "Play"
	else:
		pause_play_btn.text = "Pause"
