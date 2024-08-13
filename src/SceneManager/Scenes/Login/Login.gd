extends Control

# Signals used to communicate with other nodes


func _ready():
	%GoogleBtn.disabled = true
	%FbBtn.disabled = true
	
func resetLoginWindow():
	%EmailInput.clear()
	%PassInput.clear()

func _on_signup_btn_pressed():
	resetLoginWindow()
	SignalsAutoload.requestChangeScene.emit(Enums.Scenes.LOBBY)
	

func _on_login_btn_pressed():
	# Change with direct calling
	var loginResult = await Server.handleRequestEmailAndPassLogin(%EmailInput.text, %PassInput.text)
	if loginResult == OK:
		handleAuthSuccess()
	else:
		Notification.showMessage("Something went wrong, please try logging in again.", 5.0)

func handleAuthSuccess():
	resetLoginWindow()
	Notification.showMessage("Login Successful!", 2.0)
	await get_tree().create_timer(2.0).timeout
	ScreenTransitions.load_scene("res://scenes/titleScreen/title_screen.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
