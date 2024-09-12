extends Control


func resetSignupWindow() -> void:
	%UsernameInput.clear()
	%EmailInput.clear()
	%PassInput.clear()
	%PassInput2.clear()

func _on_login_btn_pressed() -> void:
	resetSignupWindow()
	SceneManager.changeScene("res://scenes/ui-scenes/login-screen-v2/login_screen.tscn")


func _on_signup_btn_pressed() -> void:
	# Validation
	if %UsernameInput.text.length() == 0:
		Notification.showMessage("Username is required.", 3.0)
		return
	
	if %EmailInput.text.length() == 0:
		Notification.showMessage("Email is required.", 3.0)
		return
		
	if %PassInput.text.length() < 8 or %PassInput2.text.length() < 8:
		Notification.showMessage("Password length must be 8 or longer.", 3.0)
		return
		
	if %PassInput.text != %PassInput2.text:
		Notification.showMessage("Passwords doesn't match.", 3.0)
		return
	#---------------------------------------------------------------------------
	# Creation of account
	var registerResult = await ServerManager.registerEmailAndPassword(%UsernameInput.text, 
		%EmailInput.text,
		%PassInput.text)
		
	if registerResult == FAILED:
		Notification.showMessage("Error occured during user registration, please ensure proper inputs and try again.", 3.0)
		return
	
	if registerResult == 1000:
		Notification.showMessage("Email already in use.", 3.0)
		return
		
	# Addition of account in DB
	var addUserToDBResult = await ServerManager.addUserInDB()
	if addUserToDBResult != OK:
		Notification.showMessage("Error occured during user registration, please ensure proper inputs and try again.", 3.0)
		return
	
	Notification.showMessage("User registered successfully!", 3.0)
	await get_tree().create_timer(3.0).timeout
	SceneManager.changeScene("res://scenes/ui-scenes/title-screen/title_screen.tscn")
		
		
