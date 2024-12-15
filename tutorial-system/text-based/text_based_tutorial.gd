# Text Based Tutorial
extends Control

@onready var text_box: ColorRect = $TextBox
@onready var desc: Label = $TextBox/Desc

# insert text_data (tres file)
@export var text_data : TutorialTextData
@onready var label: Label = $TextBox/Label


# Keep track of the current step
var current_step : int = 0

var blink_tween : Tween

# signal to make consecutive tutorial text
signal next_tutorial

func _ready() -> void:
	label_text_blink()

func _input(event: InputEvent) -> void:
	# check for a mouse click event
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# move to the next step of the tutorial
		current_step += 1
		
		# If we've reached the end of the tutorial, reset to the beginning
		if current_step >= text_data.tutorial_steps.size():
			# code below loops back to the first line of text
			#current_step = 0
			
			# the code below sets it to hide
			#visible = false
			
			# emits the signal to make do whatever
			next_tutorial.emit()
		
		else:
			update_tutorial_text()

# updating the text data
func update_tutorial_text() -> void:
	# set the label text for the current step
	desc.text = text_data.tutorial_steps[current_step]


# changing the position of the textbox
func set_text_box_position(x: int, y: int) -> void:
	text_box.position = Vector2(x, y)

func label_text_blink() -> void:
	# create new tween for blinking
	blink_tween = create_tween()
	
	# set the tween to loop
	blink_tween.set_loops()
	
	# fade out
	blink_tween.tween_property(label, "modulate:a", 0.0, 0.5)
	
	# fade in
	blink_tween.tween_property(label, "modulate:a", 1.0, 0.5)
