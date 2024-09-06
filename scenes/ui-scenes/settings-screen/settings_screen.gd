extends Control


func _ready() -> void:
	pass

func _on_close_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/title-screen/title_screen.tscn")
