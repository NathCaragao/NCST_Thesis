extends StaticBody2D

@onready var close: Sprite2D = $Close
@onready var open: Sprite2D = $Open

func sprite_open() -> void:
	close.visible = false
	open.visible = true

func sprite_close() -> void:
	close.visible = true
	open.visible = false
