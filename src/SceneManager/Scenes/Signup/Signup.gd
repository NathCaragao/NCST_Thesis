extends Control


func resetSignupWindow():
	%UsernameInput.clear()
	%EmailInput.clear()
	%PassInput.clear()
	%PassInput2.clear()

func _on_login_btn_pressed():
	resetSignupWindow()
	SceneManager.changeScene("res://src/SceneManager/Scenes/Login/Login.tscn")


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
		var registerResult = await ServerManager.registerEmailAndPassword(%UsernameInput.text, 
			%EmailInput.text,
			%PassInput.text)
			
		if registerResult == OK:
			#await Server.createUserInDBasync()
			Notification.showMessage("User registered successfully!", 3.0)
			await get_tree().create_timer(3.0).timeout
			SceneManager.changeScene("res://src/SceneManager/Scenes/Loading/Loading.tscn")
		else:
			Notification.showMessage("Error occured during user registration, please ensure proper inputs and try again.", 3.0)
	else:
		Notification.showMessage("Passwords doesn't match.", 3.0)
