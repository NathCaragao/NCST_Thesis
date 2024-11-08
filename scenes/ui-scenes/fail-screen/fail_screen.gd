extends Control


# restart btn
func _on_restart_btn_pressed() -> void:
	get_tree().reload_current_scene()
	visible = false


func open() -> void:
	show()

func close() -> void:
	hide()
