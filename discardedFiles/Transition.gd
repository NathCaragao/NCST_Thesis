extends CanvasLayer

signal fadeOutDone

func fadeIn():
	%AnimationPlayer.play("fadeIn")

func fadeOut():
	%ColorRect.show()
	%AnimationPlayer.play("fadeOut").finished
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fadeOut":
		fadeOutDone.emit()
		fadeIn()
	elif anim_name == "fadeIn":
		%ColorRect.hide()
