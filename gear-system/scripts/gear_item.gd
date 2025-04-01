class_name GearItem
extends Resource
enum Rarity {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}
@export_category("Gear Properties")
@export var name : String = "Unnamed Gear"
@export var gear_rarity : Rarity = Rarity.COMMON
@export_category("Core Stats")
@export var hp : float = 0
@export var atk : float = 0
@export var def : float = 0
@export var spd : float = 0
@export_category("Appearance")
@export var texture : Texture2D = null 
@export var description : String
func get_stat_string() -> String:
	return "Name: %s\nRarity: %s\nHP: %d\nATK: %d\nDEF: %d\nSPD: %d" % [
		name,
		Rarity.keys()[gear_rarity],
		hp,
		atk,
		def,
		spd
	]
