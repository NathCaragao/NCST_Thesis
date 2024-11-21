extends Control

func play() -> void:
	Dialogic.start("S7_opening") # plays the dialog
	await Dialogic.timeline_ended # waits for the dialog to end
	
	LevelScreenTransition.transition() # play fade in transition
	await LevelScreenTransition.on_transition_finished # wait for the transtion to finished

func close() -> void:
	queue_free()
