class_name Chest
extends Node2D

func open() -> void:
	$Closed.visible = false
	$Opened.visible = true

func close() -> void:
	$Opened.visible = false
	$Closed.visible = true
