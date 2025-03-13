extends Control

@onready var isUserLoggedIn = false
@export var settings_window : Control
@export var login_window : Control
@export var signup_window : Control

func _ready() -> void:
	%UserInfo.hide()
	QuestUi.get_node('CanvasLayer').hide()

func _on_start_btn_pressed() -> void:
	SceneManager.showLoadingScreen()
	isUserLoggedIn = await ServerManager.isUserLoggedIn()
	SceneManager.hideLoadingScreen()
	if not isUserLoggedIn:
		Notification.showMessage("Please login first.", 3.0)
		login_open()
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

func _on_button_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/level-selection/level_selection_2.tscn")

func login_open() -> void:
	login_window.visible = true
	var tween = create_tween()
	
	var screen_size = get_viewport_rect().size
	login_window.position.y = screen_size.y

	tween.tween_property(login_window, "position:y", screen_size.y / 2 - login_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)

func open_settings() -> void:
	settings_window.visible = true
	
	var tween = create_tween()
	
	var screen_size = get_viewport_rect().size
	settings_window.position.y = screen_size.y

	tween.tween_property(settings_window, "position:y", screen_size.y / 2 - settings_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
