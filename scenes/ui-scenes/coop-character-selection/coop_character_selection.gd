extends Control
@onready var hercules: AnimatedSprite2D = $Panel/Hercules
@onready var atalanta: AnimatedSprite2D = $Panel/Atalanta
@onready var character_name: Label = $CharacterName
var index_number : int = 0
var max_index : int = 1
func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()
	update_character_selection()
func update_character_selection() -> void:
	if index_number == 0:
		hercules_show()
	elif index_number == 1:
		atalanta_show()
func _on_prev_btn_pressed() -> void:
	index_number -= 1
	if index_number < 0:
		index_number = max_index
	update_character_selection()
func _on_next_btn_pressed() -> void:
	index_number += 1
	if index_number > max_index:
		index_number = 0
	update_character_selection()
func hercules_show() -> void:
	character_name.text = "HERCULES"
	atalanta.visible = false
	hercules.visible = true
func atalanta_show() -> void:
	character_name.text = "ATALANTA"
	hercules.visible = false
	atalanta.visible = true
func _on_confirm_btn_pressed() -> void:
	if index_number == 0:
		print("HERCULES SELECTED")
	elif index_number == 1:
		print("ATALANTA SELECTED")
func _on_back_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/game-mode-screen/game_mode_screen.tscn")
