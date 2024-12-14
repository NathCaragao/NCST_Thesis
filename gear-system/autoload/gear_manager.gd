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

# SPRITE APPEARANCES FOR DIFFERENT RARITIES
const GEAR_SPRITES = {
	GearItem.Rarity.COMMON: [
		"res://gear-system/assets/Roman_GuildCrafter00.png",
		"res://gear-system/assets/Roman_EmeraldPath00.png",
		"res://gear-system/assets/Roman_SeasideCityState00.png"
	],
	GearItem.Rarity.RARE: [
		"res://gear-system/assets/Roman_DarkCenturion00.png",
		"res://gear-system/assets/Roman_BronzeSmith00.png",
		"res://gear-system/assets/Roman_AncientHero00.png"
	],
	GearItem.Rarity.EPIC: [
		"res://gear-system/assets/Roman_Salamander00.png",
		"res://gear-system/assets/Roman_HellforgedLegion00.png",
		"res://gear-system/assets/Roman_CherryBlossomCourt00.png"
	],
	GearItem.Rarity.LEGENDARY: [
		"res://gear-system/assets/Roman_StormDrooper00.png",
		"res://gear-system/assets/Roman_Triarii00.png",
		"res://gear-system/assets/Roman_Tribune00.png"
	]
}

# Add this function to your existing GearManager script
func get_random_sprite_for_rarity(rarity: GearItem.Rarity) -> Texture2D:
	# Ensure the rarity exists in the GEAR_SPRITES dictionary
	if rarity in GEAR_SPRITES:
		# Get the array of sprites for this rarity
		var sprites = GEAR_SPRITES[rarity]
		
		# Return a random sprite from the array
		return load(sprites[randi() % sprites.size()])
		
	# Fallback to a default sprite if something goes wrong
	return load("res://gear-system/assets/Roman_GuildCrafter00.png")

# base stat values
const BASE_STATS = {
	"hp": 10,
	"atk": 5,
	"def": 5,
	"spd": 5
}

func randomize_gear_stats(gear : GearItem) -> void:
	# Get the multiplier range for the gear's rarity
	var multipliers = RARITY_STAT_MULTIPLIERS[gear.gear_rarity]
	
	# Randomize each stat
	gear.hp = _randomize_stat(BASE_STATS["hp"], multipliers)
	gear.atk = _randomize_stat(BASE_STATS["atk"], multipliers)
	gear.def = _randomize_stat(BASE_STATS["def"], multipliers)
	gear.spd = _randomize_stat(BASE_STATS["spd"], multipliers)
	
	 # Generate a random name based on rarity
	gear.name = _generate_gear_name(gear.gear_rarity)

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
	new_gear.gear_rarity = desired_rarity
	randomize_gear_stats(new_gear)
	return new_gear
