class_name CharacterInfoScreen
extends Control

# characters
@onready var hercules: CharacterBody2D = $Hercules
@onready var atalanta: CharacterBody2D = $Atalanta

# stat labels
@onready var atk_label: Label = $VBoxContainer/HBoxContainer2/AtkLabel
@onready var def_label: Label = $VBoxContainer2/HBoxContainer2/DefLabel
@onready var spd_label: Label = $VBoxContainer2/HBoxContainer3/SpdLabel
@onready var hp_label: Label = $VBoxContainer/HBoxContainer/HpLabel

# int var for updating
var atk_val : float
var hp_val : float
var def_val : float
var spd_val : float



func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()
	update_character_stats()

# character slot 1
func _on_btn_1_pressed() -> void:
	update_character_stats()
	atalanta.visible = false
	hercules.visible = true

# character slot 2
func _on_btn_2_pressed() -> void:
	update_character_stats()
	hercules.visible = false
	atalanta.visible = true

func update_character_stats() -> void:
	hp_val = PlayerManager.player_health
	atk_val = PlayerManager.player_attack
	def_val = PlayerManager.player_defense
	spd_val = PlayerManager.player_move_speed
	
	
	hp_label.text = "Health: " + str(hp_val)
	atk_label.text = "Attack: " + str(atk_val)
	def_label.text = "Defense: " + str(def_val)
	spd_label.text = "Speed: " + str(spd_val)
