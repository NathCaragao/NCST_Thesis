extends Node

enum Scenes {
	LOGIN,
	SIGN_UP,
	LOBBY
}


func _ready():
	changeScene("res://src/SceneManager/Scenes/Login/Login.tscn")

func changeScene(pathOfsceneToDisplay : String):
	# Load the scene to display first, target : add loading screen
	var instanceOfScene = await ResourceLoader.load(pathOfsceneToDisplay)
	
	# Add the instance scene to the tree
	%Transition.fadeOut()
	await %Transition.fadeOutDone
	%CurrentScene.remove_child(get_child(0))
	%CurrentScene.add_child(instanceOfScene.instantiate())

