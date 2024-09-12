extends CanvasLayer

@onready var loggedInUser : NakamaAPI.ApiAccount = null

func _ready() -> void:
	%UserInfo.hide()


func _on_close_user_info_btn_pressed() -> void:
	%UserInfo.hide()


func _on_logout_btn_pressed() -> void:
	%LogoutBtn.disabled = true
	SceneManager.showLoadingModal()
	await ServerManager.logoutUser()
	SceneManager.hideLoadingModal()
	%UserInfo.hide()
	%LogoutBtn.disabled = false


func _on_visibility_changed() -> void:
	print_debug(loggedInUser)
	%LoggedInUser.text = loggedInUser.email
