class_name GearItem
extends Resource

# SCRIPT RESOURCE FOR MAKING GEAR ITEMS
# FIRST STEP OF MAKING AN ITEM
# DON'T FORGET TO SAVE THE RESOURCE AS tres file

# gear rarity types
enum Rarity {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

# basic gear properties
@export_category("Gear Properties")
@export var name : String = "Unnamed Gear"
@export var gear_rarity : Rarity = Rarity.COMMON

@export_category("Core Stats")
@export var hp : float = 0
@export var atk : float = 0
@export var def : float = 0
@export var spd : float = 0

# optional additional properties
@export_category("Appearance")
@export var texture : Texture2D
@export var description : String

# Function to create a string representation of the gear
func get_stat_string() -> String:
	return "Name: %s\nRarity: %s\nHP: %d\nATK: %d\nDEF: %d\nSPD: %d" % [
		name,
		Rarity.keys()[gear_rarity],
		hp,
		atk,
		def,
		spd
	]
