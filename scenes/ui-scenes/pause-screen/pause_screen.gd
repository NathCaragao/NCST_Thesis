extends Control

func open() -> void:
	show()

func close() -> void:
	hide()


func _on_resume_btn_pressed() -> void:
	close()
	get_tree().paused = false
