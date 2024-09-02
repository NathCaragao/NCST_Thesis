extends Node

enum Scenes {
	LOGIN,
	SIGN_UP,
	LOBBY
}


func _ready():
	changeScene("res://scenes/ui-scenes/login-screen-v2/login_screen.tscn")

func changeScene(pathOfsceneToDisplay : String):
	# Load the scene to display first, target : add loading screen
	var instanceOfScene = await ResourceLoader.load(pathOfsceneToDisplay).instantiate()
	
	# Add the instance scene to the tree
	%Transition.fadeOut()
	await %Transition.fadeOutDone
	%CurrentScene.remove_child(get_child(0))
	%CurrentScene.add_child(instanceOfScene)
