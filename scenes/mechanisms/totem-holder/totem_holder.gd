class_name TotemHolder
extends Node2D

@onready var totem_item: Sprite2D = $TotemItem

func activate_totem() -> void:
	totem_item.visible = true
