# stat upgrade.gd
extends Control

@export var frame_hover_1 : TextureRect
@export var frame_hover_2 : TextureRect
@export var frame_hover_3 : TextureRect
@export var frame_hover_4 : TextureRect

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

# ITEM 1
func item1_entered() -> void:
	frame_hover_1.visible = true
	display_item_info(atk_name, atk_effect, atk_desc)

func item1_exited() -> void:
	frame_hover_1.visible = false
	clear_info_display()


# ITEM 2
func item2_entered() -> void:
	frame_hover_2.visible = true
	display_item_info(hp_name, hp_effect, hp_desc)

func item2_exited() -> void:
	frame_hover_2.visible = false
	clear_info_display()


# ITEM 3
func item3_entered() -> void:
	frame_hover_3.visible = true
	display_item_info(def_name, def_effect, def_desc)

func item3_exited() -> void:
	frame_hover_3.visible = false
	clear_info_display()


# ITEM 4
func item4_entered() -> void:
	frame_hover_4.visible = true
	display_item_info(speed_name, speed_effect, speed_desc)

func item4_exited() -> void:
	frame_hover_4.visible = false
	clear_info_display()

func display_item_info(item_name: String, item_effect: String, item_desc: String) -> void:
	statname.text = item_name
	stat_effect.text = item_effect
	stat_desc.text = item_desc

func clear_info_display() -> void:
	statname.text = ""
	stat_effect.text = ""
	stat_desc.text = ""
