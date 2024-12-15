extends Node2D

@onready var cutscene = $cutscene
var scene_path : String = "res://scenes/cutscenes-collection/hypolita_sidestory/hypolita_side_story.tscn"
@onready var bgm = $bgm


# Called when the node enters the scene tree for the first time.
func _ready():
	CutsceneManager.set_canvas_layer(cutscene)
	Dialogic.signal_event.connect(on_dialogic_signal_play_bgm)
	
	opening_cutscene()

func on_dialogic_signal_play_bgm(event: String) -> void:
	if event == "end":
		# Play the lively audio
		if bgm:
			bgm.play()
		else:
			print("Error: 'lively' AudioStreamPlayer not found!")

func opening_cutscene() -> void:
	CutsceneManager.add_cutscene(scene_path, "opening")
	CutsceneManager.play_cutscene("opening")
