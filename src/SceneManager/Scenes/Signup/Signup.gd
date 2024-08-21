extends Control


func resetSignupWindow():
	%UsernameInput.clear()
	%EmailInput.clear()
	%PassInput.clear()
	%PassInput2.clear()

func _on_login_btn_pressed():
	resetSignupWindow()
	ScreenTransitions.load_scene("res://scenes/loginScreen/login_window.tscn")


func _on_signup_btn_pressed():
	if %UsernameInput.text.length() == 0:
		Notification.showMessage("Username is required.", 3.0)
		return
	
	if %EmailInput.text.length() == 0:
		Notification.showMessage("Email is required.", 3.0)
		return
		
	if %PassInput.text.length() < 8 or %PassInput2.text.length() < 8:
		Notification.showMessage("Password length must be 8 or longer.", 3.0)
		return
		
	if %PassInput.text == %PassInput2.text:
		var registerResult = await Server.handleRequestEmailAndPassRegister(%UsernameInput.text, 
			%EmailInput.text,
			%PassInput.text)
		
		if registerResult == OK:
			await Server.createUserInDBasync()
			Notification.showMessage("User registered successfully!", 3.0)
			await get_tree().create_timer(3.0).timeout
			ScreenTransitions.load_scene("res://scenes/titleScreen/title_screen.tscn")
		else:
			Notification.showMessage("Error occured during user registration, please ensure proper inputs and try again.", 3.0)
	else:
		Notification.showMessage("Passwords doesn't match.", 3.0)
