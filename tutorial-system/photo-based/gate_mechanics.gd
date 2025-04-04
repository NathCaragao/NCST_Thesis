extends Control
@onready var texture_rect: TextureRect = $AspectRatioContainer/TextureRect
@onready var desc: RichTextLabel = $Desc
var images = [
	preload("res://tutorial-system/assets-material/gate_ss.png"),
	preload("res://tutorial-system/assets-material/key_ss.png"),
	preload("res://tutorial-system/assets-material/gate_2_ss.png"),
	preload("res://tutorial-system/assets-material/lever_ss.png")
]
var current_index = 0
func _ready() -> void:
	update_image()
func update_image() -> void:
	if current_index >= 0 and current_index < images.size():
		texture_rect.texture = images[current_index]
func _on_next_pressed() -> void:
	current_index += 1
	if current_index >= images.size():
		current_index = 0 
	update_image()
func _on_prev_pressed() -> void:
	current_index -= 1
	if current_index < 0:
		current_index = images.size() - 1 
	update_image()
func close_tween_anim() -> void:
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): visible = false)
func _on_close_btn_pressed() -> void:
	close_tween_anim()
