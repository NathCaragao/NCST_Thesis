extends Node2D

@export var interaction_area: Area2D
@export var dialog_file : String = ""
var dialog_played : bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_interact")


func on_interact() -> void:
	play_dialog()

func play_dialog() -> void:
	if not dialog_played:
		Dialogic.start(dialog_file)
		dialog_played = true
		print("Dialog currently playing: ", dialog_file)
