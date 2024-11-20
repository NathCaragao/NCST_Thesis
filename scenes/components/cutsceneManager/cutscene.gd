extends Node2D

@export var dialog_file: String = ""
@export var playlevel: String = ""  # Path to the next scene

func _ready():
	# Start the Dialogic dialog
	if dialog_file != "":
		Dialogic.start(dialog_file)
		Dialogic.timeline_ended.connect(change_scene)
	
func change_scene():
	# Change to the scene specified in 'playlevel'
	if playlevel != "":
		get_tree().change_scene_to_file(playlevel)
	else:
		print("Error: 'playlevel' is not set!")
