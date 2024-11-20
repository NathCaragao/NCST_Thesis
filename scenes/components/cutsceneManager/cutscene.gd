extends Control

@export var dialog_file: String = ""  # Path to the dialog file
@export var playlevel: String = ""   # Path to the next scene
@export var target_node: Node = null  # The node to make invisible

var dialog_instance  # To keep track of the Dialogic instance

func _ready():
	# Start the Dialogic dialog
	target_node.visible = true
	if dialog_file != "":
		dialog_instance = Dialogic.start(dialog_file)
		add_child(dialog_instance)
		dialog_instance.connect("dialogic_signal", Callable(self, "_on_dialogic_signal"))
		Dialogic.signal_event.connect(_on_dialogic_signal)
	else:
		print("Error: Empty Dialog file!")

func _on_dialogic_signal(event: String):
	print("event")
	if event == "end":
		change_scene()

func change_scene():

	# Change to the scene specified in 'playlevel'
	if playlevel != "":
		# Play screen transition
		LevelScreenTransition.transition()
		await LevelScreenTransition.on_transition_finished  # Wait for the transition to end
		
		
		# Cleanup Dialogic instance
		if dialog_instance:
			print("cleanup")
			dialog_instance = null
			
			
		# Make the target node invisible	
		if target_node:
			if target_node.has_method("set_visible"):
				target_node.visible = false
				print("Target node has been made invisible.")
			else:
				print("Error: Target node does not support visibility!")
		else:
			print("Error: 'target_node' is not set!")
		SceneManager.changeScene(playlevel)
		
	else:
		print("Error: 'playlevel' is not set!")
