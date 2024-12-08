extends Control

@export var frame_hover_1 : TextureRect
@export var frame_hover_2 : TextureRect
@export var frame_hover_3 : TextureRect
@export var frame_hover_4 : TextureRect

# ITEM 1
func item1_entered() -> void:
	frame_hover_1.visible = true

func item1_exited() -> void:
	frame_hover_1.visible = false


# ITEM 2
func item2_entered() -> void:
	frame_hover_2.visible = true

func item2_exited() -> void:
	frame_hover_2.visible = false


# ITEM 3
func item3_entered() -> void:
	frame_hover_3.visible = true

func item3_exited() -> void:
	frame_hover_3.visible = false


# ITEM 4
func item4_entered() -> void:
	frame_hover_4.visible = true

func item4_exited() -> void:
	frame_hover_4.visible = false
