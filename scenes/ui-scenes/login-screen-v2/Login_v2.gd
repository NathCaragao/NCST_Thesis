extends Control


func _ready():
	pass
	
func resetLoginWindow():
	%EmailInput.clear()
	%PassInput.clear()

func _on_signup_btn_pressed():
	resetLoginWindow()
	SceneManager.changeScene("res://scenes/ui-scenes/sign-up-screen/sign_up_screen.tscn")
	

func _on_login_btn_pressed():
	# Disable the button to prevent rapid-fire login press
	%LoginBtn.disabled = true
	# Show loading modal first
	SceneManager.showLoadingModal()
	
	# Validate the fields first
	# 1. Make sure no fields are empty.
	if(%EmailInput.text == "" || %PassInput.text == ""):
		Notification.showMessage("Please fill up empty fields.", 10)
	else:
		var result = await ServerManager.loginWithEmailAndPassword(%EmailInput.text, %PassInput.text)
		if result == OK:
			# Hide loading modal, before changing scene
			SceneManager.hideLoadingModal()
			Notification.showMessage("Login succesfully!", 3)
			await get_tree().create_timer(3.0).timeout
			# Change screen to title screen
			SceneManager.changeScene("res://scenes/ui-scenes/title-screen/title_screen.tscn")
		else:
			Notification.showMessage("Login failed, please try again.", 3)
	# enable the login button
	%LoginBtn.disabled = false
	# Hide loading modal	
	SceneManager.hideLoadingModal()

func _on_close_btn_pressed():
	SceneManager.changeScene("res://scenes/ui-scenes/title-screen/title_screen.tscn")
