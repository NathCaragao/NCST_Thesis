extends Control

@onready var isUserLoggedIn = false

func _ready() -> void:
	%UserInfo.hide()

func _on_start_btn_pressed() -> void:
	SceneManager.showLoadingScreen()
	isUserLoggedIn = await ServerManager.isUserLoggedIn()
	SceneManager.hideLoadingScreen()
	if not isUserLoggedIn:
		Notification.showMessage("Please login first.", 3.0)
		return
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")


func _on_option_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/settings-screen/settings_screen.tscn")


func _on_switch_acc_pressed() -> void:
	SceneManager.showLoadingModal()
	isUserLoggedIn = await ServerManager.isUserLoggedIn()
	if !isUserLoggedIn:
		SceneManager.hideLoadingModal()
		SceneManager.changeScene("res://scenes/ui-scenes/login-screen-v2/login_screen.tscn")
	else:
		%UserInfo.loggedInUser = await ServerManager.getUserLoggedInInfo()
		SceneManager.hideLoadingModal()
		%UserInfo.show()


func _on_exit_btn_pressed() -> void:
	get_tree().quit()

# Dev btn
func _on_button_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/lobby-screen/lobby_screen.tscn")
