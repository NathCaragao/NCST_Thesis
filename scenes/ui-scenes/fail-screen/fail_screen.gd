extends Control

@export var current_level_path : String

# restart btn
func _on_restart_btn_pressed() -> void:
	SceneManager.restartScene(current_level_path)
	visible = false


func open() -> void:
	show()

func close() -> void:
	hide()
