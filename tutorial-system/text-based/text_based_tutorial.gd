# Text Based Tutorial
extends Control

@onready var text_box: ColorRect = $TextBox
@onready var desc: Label = $TextBox/Desc

# insert text_data (tres file)
@export var text_data : TutorialTextData


# Keep track of the current step
var current_step : int = 0

# signal to make consecutive tutorial text
signal next_tutorial

func _input(event: InputEvent) -> void:
	# check for a mouse click event
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# move to the next step of the tutorial
		current_step += 1
		
		# If we've reached the end of the tutorial, reset to the beginning
		if current_step >= text_data.tutorial_steps.size():
			current_step = 0
			visible = false
			next_tutorial.emit()
		
		update_tutorial_text()

# updating the text data
func update_tutorial_text() -> void:
	# set the label text for the current step
	desc.text = text_data.tutorial_steps[current_step]


# changing the position of the textbox
func set_text_box_position(x: int, y: int) -> void:
	text_box.position = Vector2(x, y)
