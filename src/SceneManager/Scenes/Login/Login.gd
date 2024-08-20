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
	SceneManager.changeScene(SceneManager.Scenes.SIGN_UP)
	

func _on_login_btn_pressed():
	# Validate the fields first
	# 1. Make sure no fields are empty.
	if(%EmailInput.text == null || %PassInput.text == null):
		# idk if send a signal, and if signal, what signal?
		pass
	
	# Just send the credentials through signal, no need to wait for its result
	# since other nodes will take care of it.

#func handleAuthSuccess():
	#resetLoginWindow()
	#Notification.showMessage("Login Successful!", 2.0)
	#await get_tree().create_timer(2.0).timeout
	#ScreenTransitions.load_scene("res://scenes/titleScreen/title_screen.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
