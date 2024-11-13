class_name DialogActivator
extends Area2D

# enter the dialog file name you want to play
@export var dialog_file : String = ""

var dialog_played : bool = false

# setting the collision mask to interact with the player
func _ready() -> void:
	collision_layer = 0
	collision_mask = 8

func play_dialog() -> void:
	if not dialog_played:
		Dialogic.start(dialog_file)
		dialog_played = true
		print("Dialog currently playing: ", dialog_file)

# insert body entered signal here
func _on_body_entered(body: Node2D) -> void:
	play_dialog()
