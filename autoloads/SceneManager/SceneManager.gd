extends Node
func _ready() -> void:
	changeScene("res://scenes/ui-scenes/title-screen/title_screen.tscn")
	hideLoadingScreen()
	hideLoadingModal()
func showLoadingScreen() -> void:
	%LoadingScreen.show()
func hideLoadingScreen() -> void:
	%LoadingScreen.hide()
func showLoadingModal() -> void:
	%LoadingModal.show()
func hideLoadingModal() -> void:
	%LoadingModal.hide()
func changeScene(pathOfsceneToDisplay : String) -> void:
	showLoadingScreen()
	var loadedScene = await ResourceLoader.load(pathOfsceneToDisplay)
	var instanceOfLoadedScene = loadedScene.instantiate()
	instanceOfLoadedScene.ready.connect(hideLoadingScreen)
	for n in %CurrentScene.get_children():
		%CurrentScene.remove_child(n)
		n.queue_free()
	%CurrentScene.add_child(instanceOfLoadedScene)

func restartScene(pathOfsceneToDisplay : String) -> void:
	showLoadingScreen()
	var loadedScene = await ResourceLoader.load(pathOfsceneToDisplay)
	var instanceOfLoadedScene = loadedScene.instantiate()
	instanceOfLoadedScene.ready.connect(hideLoadingScreen)
	for n in %CurrentScene.get_children():
		%CurrentScene.remove_child(n)
		n.queue_free()
	%CurrentScene.add_child(instanceOfLoadedScene)