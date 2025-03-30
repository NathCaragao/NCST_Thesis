extends Control

func play() -> void:
	Dialogic.start("S7_opening")
	await Dialogic.timeline_ended 
	
	LevelScreenTransition.transition() 
	await LevelScreenTransition.on_transition_finished 
	
	close()
func close() -> void:
	queue_free()
