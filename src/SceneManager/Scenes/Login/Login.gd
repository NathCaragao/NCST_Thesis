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
	SceneManager.changeScene("res://src/SceneManager/Scenes/Loading/Loading.tscn")
	

func _on_login_btn_pressed():
	# Validate the fields first
	# 1. Make sure no fields are empty.
	if(%EmailInput.text == "" || %PassInput.text == ""):
		Notification.showMessage("Please fill up empty fields.", 10)
	else:
		var result = await ServerManager.loginWithEmailAndPassword(%EmailInput.text, %PassInput.text)
		if result == OK:
			Notification.showMessage("Login succesfully!", 3)
			SceneManager.changeScene("res://src/SceneManager/Scenes/Loading/Loading.tscn")
		else:
			Notification.showMessage("Login failed, please try again.", 3)
	
	

#func handleAuthSuccess():
	#resetLoginWindow()
	#Notification.showMessage("Login Successful!", 2.0)
	#await get_tree().create_timer(2.0).timeout
	#ScreenTransitions.load_scene("res://scenes/titleScreen/title_screen.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
