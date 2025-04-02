extends Control
func play() -> void:
	LevelScreenTransition.transition() 
	await LevelScreenTransition.on_transition_finished 
	Dialogic.start("S10_ending") 
	await Dialogic.timeline_ended 
	LevelScreenTransition.transition() 
	await LevelScreenTransition.on_transition_finished 
	close()
func close() -> void:
	queue_free()
