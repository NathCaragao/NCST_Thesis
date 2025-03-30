class_name DialogActivator
extends Area2D

@export var dialog_file : String = ""
var dialog_played : bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 8 # value of the mask 4

func play_dialog() -> void:
	if not dialog_played:
		Dialogic.start(dialog_file)
		dialog_played = true
		print("Dialog currently playing: ", dialog_file)

func _on_body_entered(body: Node2D) -> void:
	play_dialog()
