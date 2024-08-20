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
	Notification.showMessage("SUP BITCH", 1)
	

func _on_login_btn_pressed():
	# Validate the fields first
	# 1. Make sure no fields are empty.
	if(%EmailInput.text == "" || %PassInput.text == ""):
		Notification.showMessage("Please fill up empty fields.", 10)
	

#func handleAuthSuccess():
	#resetLoginWindow()
	#Notification.showMessage("Login Successful!", 2.0)
	#await get_tree().create_timer(2.0).timeout
	#ScreenTransitions.load_scene("res://scenes/titleScreen/title_screen.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
