# SKIN CHANGER
extends Node

# Dictionary to store skins for different animations
var skins = {
	"default": {
		"idle": preload("res://assets/character/sprites/hercules_idle1.png"),
		"run": preload("res://assets/character/sprites/player run1 48x48.png"),
		"jump": preload("res://assets/character/sprites/player jump 48x48.png"),
		"attack1": preload("res://assets/character/sprites/player sword atk 64x64.png"),
		"attack2": preload("res://assets/character/sprites/player sword atk 64x64.png"),
		"death": preload("res://assets/character/sprites/Player Death 64x64 Hercules.png")
	},
	"skin1": {
		"idle": preload("res://assets/hercules-skins/dark-armor/hercules_idle1.png"),
		"run": preload("res://assets/hercules-skins/dark-armor/player run1 48x48.png"),
		"jump": preload("res://assets/hercules-skins/dark-armor/player jump 48x48.png"),
		"attack1": preload("res://assets/hercules-skins/dark-armor/player sword atk 64x64.png"),
		"attack2": preload("res://assets/hercules-skins/dark-armor/Player Sword Stab2 96x48-Sheet.png"),
		"death": preload("res://assets/character/sprites/Player Death 64x64 Hercules.png")
	}
}

# Current active skin
var current_skin = "default"

# Change the current skin
func change_skin(new_skin: String):
	if skins.has(new_skin):
		current_skin = new_skin
		# Optionally emit a signal if you want other scripts to know
		skin_changed.emit(new_skin)
	else:
		print("Skin not found: ", new_skin)

# Signal to notify when skin changes
signal skin_changed(new_skin)

# Get the sprite for a specific animation
func get_sprite(animation_name: String) -> Texture2D:
	return skins[current_skin][animation_name]
