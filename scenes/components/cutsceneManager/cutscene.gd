extends Control

@export var dialog_file: String = ""
@export var playlevel: String = ""  # Path to the next scene

func _ready():
	# Start the Dialogic dialog
	if dialog_file != "":
		Dialogic.start(dialog_file)
		Dialogic.timeline_ended.connect(change_scene)
	else:
		print("Error: Empty Dialog file!")
	
func change_scene():
	# Change to the scene specified in 'playlevel'
	if playlevel != "":
		# play screen transtion
		LevelScreenTransition.transition()
		await LevelScreenTransition.on_transition_finished # waits for the transition to end
		
		SceneManager.changeScene(playlevel)
	else:
		print("Error: 'playlevel' is not set!")
