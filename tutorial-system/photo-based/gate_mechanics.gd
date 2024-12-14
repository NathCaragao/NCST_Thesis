extends Control


@onready var texture_rect: TextureRect = $AspectRatioContainer/TextureRect

#--------------------------------
# IMAGE VIEWER
#--------------------------------

# array of images
var images = [
	preload("res://tutorial-system/assets-material/gate_ss.png"),
	preload("res://tutorial-system/assets-material/key_ss.png"),
	preload("res://tutorial-system/assets-material/gate_2_ss.png"),
	preload("res://tutorial-system/assets-material/lever_ss.png")
]

# Index to track the current image
var current_index = 0

func _ready() -> void:
	# Initialize the first image
	update_image()

func update_image() -> void:
	if current_index >= 0 and current_index < images.size():
		texture_rect.texture = images[current_index]
		

# navigate to the next image
func _on_next_pressed() -> void:
	current_index += 1
	if current_index >= images.size():
		current_index = 0 # loop back to the first image
	update_image()

# navigate to the previous image
func _on_prev_pressed() -> void:
	current_index -= 1
	if current_index < 0:
		current_index = images.size() - 1 # loop back to the first image
	update_image()
