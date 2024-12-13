# GEAR MANAGER AUTOLOAD
extends Node

# stat ranges for different rarities

const RARITY_STAT_MULTIPLIERS = {
	GearItem.Rarity.COMMON: {
		"min_multiplier": 0.5,
		"max_multiplier": 1.0
	},
	GearItem.Rarity.RARE: {
		"min_multiplier": 0.7,
		"max_multiplier": 1.3
	},
	GearItem.Rarity.EPIC: {
		"min_multiplier": 1.3,
		"max_multiplier": 2.0
	},
	GearItem.Rarity.LEGENDARY: {
		"min_multiplier": 1.7,
		"max_multiplier": 2.5
	},
}

# base stat values
const BASE_STATS = {
	"hp": 10,
	"atk": 5,
	"def": 5,
	"spd": 5
}

func randomize_gear_stats(gear : GearItem) -> void:
	# Get the multiplier range for the gear's rarity
	var multipliers = RARITY_STAT_MULTIPLIERS[gear.rarity]
	
	# Randomize each stat
	gear.hp = _randomize_stat(BASE_STATS["hp"], multipliers)
	gear.attack = _randomize_stat(BASE_STATS["atk"], multipliers)
	gear.defense = _randomize_stat(BASE_STATS["def"], multipliers)
	gear.speed = _randomize_stat(BASE_STATS["spd"], multipliers)
	
	 # Generate a random name based on rarity
	gear.name = _generate_gear_name(gear.rarity)

# Helper function to randomize a single stat
func _randomize_stat(base_value: float, multipliers : Dictionary) -> float:
	var min_value = base_value * multipliers["min_multiplier"]
	var max_value = base_value * multipliers["max_multiplier"]
	return int(randf_range(min_value, max_value))

# Generate a random name based on rarity
func _generate_gear_name(rarity: GearItem.Rarity) -> String:
	var prefixes = {
		GearItem.Rarity.COMMON: ["Simple", "Basic", "Plain"],
		GearItem.Rarity.RARE: ["Refined", "Polished", "Elegant"],
		GearItem.Rarity.EPIC: ["Heroic", "Magnificent", "Powerful"],
		GearItem.Rarity.LEGENDARY: ["Divine", "Mythical", "Transcendent"]
	}
	
	var suffixes = ["Armor", "Gear", "Equipment", "Piece"]
	
	var prefix = prefixes[rarity][randi() % prefixes[rarity].size()]
	var suffix = suffixes[randi() % suffixes.size()]
	
	return "%s %s" % [prefix, suffix]


# Optional: Generate a complete random gear item
func generate_random_gear(desired_rarity: GearItem.Rarity = GearItem.Rarity.COMMON) -> GearItem:
	var new_gear = GearItem.new()
	new_gear.rarity = desired_rarity
	randomize_gear_stats(new_gear)
	return new_gear
