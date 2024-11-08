extends Node

func _ready():
	ScoreUi.get_node('CanvasLayer').hide()
	queue_free()
