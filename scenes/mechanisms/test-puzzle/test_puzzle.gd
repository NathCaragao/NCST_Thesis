class_name Puzzle
extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea as InteractionArea
@onready var anim_platform: AnimationPlayer = $"../AnimPlatform" as AnimationPlayer

var is_activated : bool = false
var is_correct : bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "on_activate")


func on_activate() -> void:
	$PuzzleOn.show()
	$PuzzleOff.hide()
	is_activated = true
	
	if is_activated:
		anim_platform.play("gate1")
		print_debug()
