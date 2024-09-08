extends Node


func _ready():
	changeScene("res://testFolder/testScenes/multi_test_lvl.tscn")

func showLoadingScreen():
	%LoadingScreen.show()

func hideLoadingScreen():
	%LoadingScreen.hide()

func changeScene(pathOfsceneToDisplay : String):
	# Load the scene to display first before iniating loading of resource, hide with loading screen
	showLoadingScreen()
	var loadedScene = await ResourceLoader.load(pathOfsceneToDisplay)
	var instanceOfLoadedScene = loadedScene.instantiate()

	# Once resource is loaded, add it to the tree and run its _ready() into it
	# _ready holds initialization stuffs like connecting to server for user info
	# so make sure to change into the scene ONLY AFTER IT IS EXECUTED
	instanceOfLoadedScene.ready.connect(hideLoadingScreen)
	for n in %CurrentScene.get_children():
		%CurrentScene.remove_child(n)
		n.queue_free()
	%CurrentScene.add_child(instanceOfLoadedScene)
