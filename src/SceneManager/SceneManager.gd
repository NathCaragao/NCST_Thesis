extends Node

enum Scenes {
	LOGIN,
	SIGN_UP,
	LOBBY
}


func _ready():
	pass

func changeScene(sceneToDisplay : String):
	load(sceneToDisplay)
	%Transition.fadeOut()
	await %Transition.fadeOutDone
	remove_child(get_child(0))
	add_child(sceneToDisplay.instantiate())
	pass

