extends Control


@export var login_window : Control

func resetSignupWindow() -> void:
	%UsernameInput.clear()
	%EmailInput.clear()
	%PassInput.clear()
	%PassInput2.clear()

func _on_login_btn_pressed() -> void:
	resetSignupWindow()
	close_tween_anim()
	login_open_window() # opens up login window


func _on_signup_btn_pressed() -> void:
	# Show loading modal
	SceneManager.showLoadingModal()
	# Disable signup button to prevent rafid-fire
	%SignupBtn.disabled = true
	
	# Validation
	if %UsernameInput.text.length() == 0:
		Notification.showMessage("Username is required.", 3.0)
		SceneManager.hideLoadingModal()
		%SignupBtn.disabled = false
		return
	
	if %EmailInput.text.length() == 0:
		Notification.showMessage("Email is required.", 3.0)
		SceneManager.hideLoadingModal()
		%SignupBtn.disabled = false
		return
		
	if %PassInput.text.length() < 8 or %PassInput2.text.length() < 8:
		Notification.showMessage("Password length must be 8 or longer.", 3.0)
		SceneManager.hideLoadingModal()
		%SignupBtn.disabled = false
		return
		
	if %PassInput.text != %PassInput2.text:
		Notification.showMessage("Passwords doesn't match.", 3.0)
		SceneManager.hideLoadingModal()
		%SignupBtn.disabled = false
		return
	#---------------------------------------------------------------------------
	# Creation of account
	var registerResult = await ServerManager.registerEmailAndPassword(%UsernameInput.text, 
		%EmailInput.text,
		%PassInput.text)
		
	if registerResult == FAILED:
		Notification.showMessage("Error occured during user registration, please ensure proper inputs and try again.", 3.0)
		SceneManager.hideLoadingModal()
		%SignupBtn.disabled = false
		return
	
	# Result when email already exists
	if registerResult == 1000:
		Notification.showMessage("Email already in use.", 3.0)
		SceneManager.hideLoadingModal()
		%SignupBtn.disabled = false
		return
		
	# Addition of account in DB
	var addUserToDBResult = await ServerManager.addUserInDB()
	if addUserToDBResult != OK:
		Notification.showMessage("Error occured during user registration, please ensure proper inputs and try again.", 3.0)
		SceneManager.hideLoadingModal()
		%SignupBtn.disabled = false
		return
	
	Notification.showMessage("User registered successfully!", 3.0)
	# Remove loading modal
	SceneManager.hideLoadingModal()
	await get_tree().create_timer(3.0).timeout
	SceneManager.changeScene("res://scenes/ui-scenes/title-screen/title_screen.tscn")
		
func _on_close_btn_pressed() -> void:
	close_tween_anim()

func close_tween_anim() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Get the screen size
	var screen_size = get_viewport_rect().size
	
	# Animate the window moving from center to bottom
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	# After the animation completes, hide the window
	tween.tween_callback(func(): visible = false)

func login_open_window() -> void:
	login_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	login_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(login_window, "position:y", screen_size.y / 2 - login_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
