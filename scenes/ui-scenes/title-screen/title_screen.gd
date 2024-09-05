extends Control

func _on_start_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")


func _on_option_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/settings-screen/settings_screen.tscn")


func _on_switch_acc_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/login-screen-v2/login_screen.tscn")
