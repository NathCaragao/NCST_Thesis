extends Control

@onready var hercules: AnimatedSprite2D = $Panel/Hercules
@onready var atalanta: AnimatedSprite2D = $Panel/Atalanta
@onready var character_name: Label = $CharacterName


# 0 FOR HERCULES
# 1 FOR ATALANTA
# 2 FOR HYPOLITA

var index_number : int = 0
var max_index : int = 1

func _ready() -> void:
	# Hide Autoload UIs
	ScoreUi.get_node('CanvasLayer').hide()
	
	# initialize default selection
	update_character_selection()


func update_character_selection() -> void:
	if index_number == 0:
		hercules_show()
	elif index_number == 1:
		atalanta_show()



func _on_prev_btn_pressed() -> void:
	# Decrease the index and loop if necessary
	index_number -= 1
	if index_number < 0:
		index_number = max_index
	update_character_selection()


func _on_next_btn_pressed() -> void:
	# Increase the index and loop if necessary
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


# CONFIRM BUTTON PRESSED
func _on_confirm_btn_pressed() -> void:
	if index_number == 0:
		print("HERCULES SELECTED")
		Notification.showMessage("Selected \"Hercules\"", 3.0)
		await ServerManager.updateUserCharacter(ServerManager.PlayableCharacter.HERCULES)
	elif index_number == 1:
		print("ATALANTA SELECTED")
		Notification.showMessage("Selected \"Atalanta\"", 3.0)
		await ServerManager.updateUserCharacter(ServerManager.PlayableCharacter.ATALANTA)

# AFTER USER PRESSED CONFIRM BUTTON REDIRECT THEM
# TO THE MULTIPLAYER SCREEN TO
# CREATE MATCH OR JOIN A MATCH
	SceneManager.changeScene("res://scenes/multiplayerLevelManager/MultiplayerLevelManager.tscn")

#  BACK BUTTON PRESSED
func _on_back_btn_pressed() -> void:
	SceneManager.changeScene("res://scenes/ui-scenes/game-mode-screen/game_mode_screen.tscn")
