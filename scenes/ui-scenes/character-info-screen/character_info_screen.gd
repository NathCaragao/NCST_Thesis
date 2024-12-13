class_name CharacterInfoScreen
extends Control

@onready var hercules: CharacterBody2D = $Hercules
@onready var atalanta: CharacterBody2D = $Atalanta


func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()

# character slot 1
func _on_btn_1_pressed() -> void:
	atalanta.visible = false
	hercules.visible = true

# character slot 2
func _on_btn_2_pressed() -> void:
	hercules.visible = false
	atalanta.visible = true
