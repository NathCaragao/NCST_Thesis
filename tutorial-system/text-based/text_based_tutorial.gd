extends Control
@onready var text_box: ColorRect = $TextBox
@onready var desc: Label = $TextBox/Desc
@export var text_data : TutorialTextData
@onready var label: Label = $TextBox/Label
var current_step : int = 0
var blink_tween : Tween
signal next_tutorial
func _ready() -> void:
	label_text_blink()
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		current_step += 1
		if current_step >= text_data.tutorial_steps.size():
			next_tutorial.emit()
		else:
			update_tutorial_text()
func update_tutorial_text() -> void:
	desc.text = text_data.tutorial_steps[current_step]
func set_text_box_position(x: int, y: int) -> void:
	text_box.position = Vector2(x, y)
func label_text_blink() -> void:
	blink_tween = create_tween()
	blink_tween.set_loops()
	blink_tween.tween_property(label, "modulate:a", 0.0, 0.5)
	blink_tween.tween_property(label, "modulate:a", 1.0, 0.5)
