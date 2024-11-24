extends Control

func play() -> void:
	
	LevelScreenTransition.transition() # play fade in transition
	await LevelScreenTransition.on_transition_finished # wait for the transtion to finished
	
	Dialogic.start("S10_ending") # plays the dialog
	await Dialogic.timeline_ended # waits for the dialog to end
	
	LevelScreenTransition.transition() # play fade in transition
	await LevelScreenTransition.on_transition_finished # wait for the transtion to finished
	
	close()
	
func close() -> void:
	queue_free()
