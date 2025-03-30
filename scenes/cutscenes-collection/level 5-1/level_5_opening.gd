extends Control

func play() -> void:
	Dialogic.start("S51_opening") 
	await Dialogic.timeline_ended 
	
	LevelScreenTransition.transition() 
	await LevelScreenTransition.on_transition_finished

func close() -> void:
	queue_free()
