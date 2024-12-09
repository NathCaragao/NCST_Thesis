# stat upgrade.gd
extends Control

@export var frame_hover_1 : TextureRect
@export var frame_hover_2 : TextureRect
@export var frame_hover_3 : TextureRect
@export var frame_hover_4 : TextureRect

# Cost Multiplier
@export var cost_multiplier : float = 1.5
@export var coins : int = 50
@export var base_cost : int = 10

# references
@onready var statname: Label = $ItemDesc/Statname
@onready var stat_effect: Label = $ItemDesc/StatEffect
@onready var stat_desc: Label = $ItemDesc/StatDesc


@export_category("Item Names")
@export var atk_name : String = "Attack"
@export var hp_name : String = "Health"
@export var def_name : String = "Defense"
@export var speed_name : String = "Speed"

@export_category("Item Effects")
@export var atk_effect : String = "Attack Power: +10.0"
@export var hp_effect : String = "Health: +20.0"
@export var def_effect : String = "Defense: +10.0"
@export var speed_effect : String = "Move Speed: +5.0"

# item informations
@export_category("Item Descriptions")
@export var atk_desc : String
@export var hp_desc : String
@export var def_desc : String
@export var speed_desc : String

# attack stat information
@export_category("Attack Cost")
@export var atk_upgrade : float = 10.0
@export var atk_cost : int = 10
@export var atk_max_level : int = 5


# health stat information
@export_category("Health Cost")
@export var hp_upgrade : float = 20.0
@export var hp_cost : int = 10
@export var hp_max_level : int = 5

# defense stat information
@export_category("Defense Cost")
@export var def_upgrade : float = 10.0
@export var def_cost : int = 10
@export var def_max_level : int = 5

# speed stat information
@export var speed_upgrade : float = 5.0
@export var speed_cost : int = 10
@export var speed_max_level : int = 5


# ITEM 1
func item1_entered() -> void:
	frame_hover_1.visible = true
	display_item_info(atk_name, atk_effect, atk_desc)

func item1_exited() -> void:
	frame_hover_1.visible = false
	#clear_info_display()


# ITEM 2
func item2_entered() -> void:
	frame_hover_2.visible = true
	display_item_info(hp_name, hp_effect, hp_desc)

func item2_exited() -> void:
	frame_hover_2.visible = false
	#clear_info_display()


# ITEM 3
func item3_entered() -> void:
	frame_hover_3.visible = true
	display_item_info(def_name, def_effect, def_desc)

func item3_exited() -> void:
	frame_hover_3.visible = false
	#clear_info_display()


# ITEM 4
func item4_entered() -> void:
	frame_hover_4.visible = true
	display_item_info(speed_name, speed_effect, speed_desc)

func item4_exited() -> void:
	frame_hover_4.visible = false
	#clear_info_display()

# upgrading the attack stat
func upgrade_attack() -> void:
	# check if users currency suffice
	if PlayerManager.coins >= atk_cost:
		if $ItemFrame1/AtkLevel.value < atk_max_level:
			# subtract atk upgrade cost from player coins
			PlayerManager.coins -= atk_cost
			# increase the attack
			PlayerManager.player_attack += atk_upgrade
			# update UI
			$ItemFrame1/AtkLevel.value += 1
		elif $ItemFrame1/AtkLevel.value == atk_max_level:
			print("Already Reached the max level!")
		
		print("Current attack:", str(PlayerManager.player_attack))
	elif PlayerManager.coins < atk_cost:
		print("You don't have enough coins")

# upgrading the health stat
func upgrade_health() -> void:
	# check if users currency suffice
	if PlayerManager.coins >= hp_cost:
		if $ItemFrame2/HpLevel.value < hp_max_level:
			# subtract hp upgrade cost from player coins
			PlayerManager.coins -= hp_cost
			# increase the health
			PlayerManager.player_health += hp_upgrade
			# update UI
			$ItemFrame2/HpLevel.value += 1
		elif $ItemFrame2/HpLevel.value == hp_max_level:
			print("Already reached the max level!")
	
	elif PlayerManager.coins < hp_cost:
		print("You don't have enough coins")

# upgrading the defense stat
func upgrade_defense() -> void:
	# check if users currency suffice
	if PlayerManager.coins >= def_cost:
		if $ItemFrame3/DefLevel.value < def_max_level:
			# subtract hp upgrade cost from player coins
			PlayerManager.coins -= def_cost
			# increase defense stat value
			PlayerManager.player_defense += def_upgrade
			# update the UI
			$ItemFrame3/DefLevel.value += 1
		elif $ItemFrame3/DefLevel.value == def_max_level:
			print("Already reached the max level!")
	
	elif PlayerManager.coins < def_cost:
		print("You don't have enough coins")

func upgrade_speed() -> void:
	# check if users currency suffice
	if PlayerManager.coins >= speed_cost:
		if $ItemFrame4/SpeedLevel.value < speed_max_level:
			# subtract hp upgrade cost from player coins
			PlayerManager.coins -= speed_cost
			# increase the speed stat
			PlayerManager.player_move_speed += speed_upgrade
			# update the UI
			$ItemFrame4/SpeedLevel.value += 1
		elif $ItemFrame4/SpeedLevel.value == speed_max_level:
			print("Already reached the max level!")
	
	elif PlayerManager.coins < speed_cost:
		print("You don't have enough coins")

func display_item_info(item_name: String, item_effect: String, item_desc: String) -> void:
	statname.text = item_name
	stat_effect.text = item_effect
	stat_desc.text = item_desc

func clear_info_display() -> void:
	statname.text = ""
	stat_effect.text = ""
	stat_desc.text = ""


func _on_atk_upgrade_pressed() -> void:
	upgrade_attack()


func _on_hp_upgrade_pressed() -> void:
	upgrade_health()


func _on_def_upgrade_pressed() -> void:
	upgrade_defense()


func _on_speed_upgrade_pressed() -> void:
	upgrade_speed()
