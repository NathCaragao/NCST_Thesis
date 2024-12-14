class_name CharacterInfoScreen
extends Control

# characters
@onready var hercules: CharacterBody2D = $Border/Hercules
@onready var atalanta: CharacterBody2D = $Border/Atalanta


# stat labels
@onready var atk_label: Label = $VBoxContainer/HBoxContainer2/AtkLabel
@onready var def_label: Label = $VBoxContainer2/HBoxContainer2/DefLabel
@onready var spd_label: Label = $VBoxContainer2/HBoxContainer3/SpdLabel
@onready var hp_label: Label = $VBoxContainer/HBoxContainer/HpLabel

@export var inv_window : Control



func _ready() -> void:
	GameSignals.connect("GearStatsApplied", Callable(self, "_on_gear_stats_apply"))
	GameSignals.connect("GearStatsRemoved", Callable(self, "_on_gear_stats_removed"))
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

func _on_gear_stats_apply() -> void:
	update_character_stats()

func _on_gear_stats_removed() -> void:
	update_character_stats()

func update_character_stats() -> void:
	hp_label.text = "Health: " + str(PlayerManager.player_health)
	atk_label.text = "Attack: " + str(PlayerManager.player_attack)
	def_label.text = "Defense: " + str(PlayerManager.player_defense)
	spd_label.text = "Speed: " + str(PlayerManager.player_move_speed)


func _on_close_btn_pressed() -> void:
	PlayerManager.character_info = false
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

func acc_inventory_open() -> void:
	inv_window.visible = true
	
	# Create a tween
	var tween = create_tween()
	
	# Set the initial position of the inventory window off-screen to the right
	var screen_size = get_viewport_rect().size
	inv_window.position.x = -screen_size.x
	
	# Animate the window moving from the right to the center
	tween.tween_property(inv_window, "position:x", 233, 0.3) \
		.set_trans(Tween.TRANS_BACK)

func acc_inventory_close() -> void:
	# Create a tween
	var tween = create_tween()
	
	# Set the initial position of the inventory window off-screen to the right
	var screen_size = get_viewport_rect().size
	
	# Animate the window moving from the right to the center
	tween.tween_property(inv_window, "position:x", -965, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	# After the animation completes, hide the window
	tween.tween_callback(func(): inv_window.visible = false)


func _on_add_gear_btn_pressed() -> void:
	acc_inventory_open()
	$InvCloseBtn.visible = true


func _on_inv_close_btn_pressed() -> void:
	acc_inventory_close()
	$InvCloseBtn.visible = false
