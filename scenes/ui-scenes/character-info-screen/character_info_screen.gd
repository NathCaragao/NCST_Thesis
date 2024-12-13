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


func _on_close_btn_pressed() -> void:
	character_info_close()

func character_info_close() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Get the screen size
	var screen_size = get_viewport_rect().size
	
	# Animate the window moving from center to bottom
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	# After the animation completes, hide the window
	tween.tween_callback(func(): visible = false)
