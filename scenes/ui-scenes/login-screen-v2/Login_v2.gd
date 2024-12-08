extends Control

@export var signup_window : Control

func _ready() -> void:
	pass
	
func resetLoginWindow() -> void:
	%EmailInput.clear()
	%PassInput.clear()

func _on_signup_btn_pressed() -> void:
	resetLoginWindow()
	close_tween_anim()
	signup_open_window()
	

func _on_login_btn_pressed() -> void:
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

func signup_open_window() -> void:
	signup_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	signup_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(signup_window, "position:y", screen_size.y / 2 - signup_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
