extends Control

@onready var isUserLoggedIn = false

@export var settings_window : Control

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

func open_settings() -> void:
	settings_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	settings_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(settings_window, "position:y", screen_size.y / 2 - settings_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
