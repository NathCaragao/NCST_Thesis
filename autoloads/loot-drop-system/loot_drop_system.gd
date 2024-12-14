# LOOT DROP SYSTEM
extends Node

# Dictionary to store preloaded items
var loot_items: Dictionary = {}

# Preload all items during the _ready function
func _ready() -> void:
	# Define the path of files
	var item_paths = {
		"coin" : "res://scenes/components/coin/coin.tscn",
		"gear" : "res://gear-system/gear(scenes)/test_gear.tscn"
	}
	
	# Preload the items and store them in the dictionary
	for key in item_paths.keys():
		loot_items[key] = load(item_paths[key])
	
	print("Loot items preloaded: ", loot_items.keys())

func instantiate_item(item_name: String, position: Vector2, parent: Node2D = null) -> Node2D:
	if not loot_items.has(item_name):
		print("Error: Item not found: ", item_name)
		return null
	
	var item_scene = loot_items[item_name]
	var item_instance = item_scene.instantiate()
	
	var target_parent = parent if parent else get_tree().current_scene
	target_parent.add_child(item_instance)
	
	if not item_instance is Node2D:
		print("Error: Instantiated item is not a Node2D")
		return item_instance
	
	# Vertical fountain parameters
	var max_height: float = 80.0  # Peak height of the fountain
	var up_horizontal_scatter: float = 50.0  # Horizontal scatter when going up
	var down_horizontal_scatter: float = 100.0  # Wider scatter when coming down
	var drop_duration: float = 0.8  # Total animation time
	
	# Scattered horizontal offset for going up
	var up_horizontal_offset = randf_range(-up_horizontal_scatter, up_horizontal_scatter)
	
	# Start position
	item_instance.position = position
	item_instance.modulate.a = 0  # Start fully transparent
	
	# Create fountain tween
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Vertical rise with slight horizontal scatter
	var rise_position = position + Vector2(
		up_horizontal_offset, 
		-max_height
	)
	
	# Randomized landing position with wider scatter
	var down_horizontal_offset = randf_range(-down_horizontal_scatter, down_horizontal_scatter)
	var landing_position = position + Vector2(down_horizontal_offset, 0)
	
	# Fade in
	tween.tween_property(item_instance, "modulate:a", 1.0, drop_duration * 0.2)
	
	# Straight vertical rise
	tween.tween_property(item_instance, "position", rise_position, drop_duration * 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	
	# Falling back down with wider scatter
	tween.tween_property(item_instance, "position", landing_position, drop_duration * 0.5)\
		.set_delay(drop_duration * 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
	# Rotation for tumbling effect
	tween.tween_property(
		item_instance, 
		"rotation", 
		deg_to_rad(randf_range(360, 720)), 
		drop_duration
	).set_trans(Tween.TRANS_LINEAR)
	
	# Scale for additional dynamism
	tween.tween_property(item_instance, "scale", Vector2(1.2, 1.2), drop_duration * 0.2)
	tween.chain().tween_property(item_instance, "scale", Vector2(1, 1), drop_duration * 0.1)
	
	## Fade out at end
	#tween.tween_property(item_instance, "modulate:a", 0.0, drop_duration * 0.2)\
		#.set_delay(drop_duration * 0.8)
	
	return item_instance

func drop_multiple_items(drop_position: Vector2, item_types: Array, item_count: int = -1) -> void:
	# If item_count is -1, use the length of item_types
	if item_count == -1:
		item_count = item_types.size()
	
	# Randomize item types if needed
	var drop_items = item_types.duplicate()
	while drop_items.size() < item_count:
		drop_items.append(item_types[randi() % item_types.size()])
	
	# Shuffle the items for more randomness
	drop_items.shuffle()
	
	# Drop items with slight stagger
	for i in range(min(item_count, drop_items.size())):
		instantiate_item(drop_items[i], drop_position)
