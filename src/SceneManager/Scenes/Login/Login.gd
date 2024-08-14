extends Control


func _ready():
	# Remove once implemented
	%GoogleBtn.disabled = true
	%FbBtn.disabled = true
	
func resetLoginWindow():
	%EmailInput.clear()
	%PassInput.clear()

func _on_signup_btn_pressed():
	resetLoginWindow()
	SignalsAutoload.requestChangeScene.emit(Enums.Scenes.LOBBY)
	

func _on_login_btn_pressed():
	# Just send the credentials through signal, no need to wait for its result.
	SignalsAutoload.requestEmailAndPassLogin.emit(%EmailInput.text, %PassInput.text)
	
	# Either finish now, or await for success message, OR trigger loading screen

#func handleAuthSuccess():
	#resetLoginWindow()
	#Notification.showMessage("Login Successful!", 2.0)
	#await get_tree().create_timer(2.0).timeout
	#ScreenTransitions.load_scene("res://scenes/titleScreen/title_screen.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
