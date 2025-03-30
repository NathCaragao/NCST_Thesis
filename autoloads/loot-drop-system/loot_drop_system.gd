extends Node
var loot_items: Dictionary = {}
func _ready() -> void:
	var item_paths = {
		"coin": "res://scenes/components/coin/coin.tscn",
		"gear": "res://gear-system/gear(scenes)/test_gear.tscn"
	}
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
	var max_height: float = 80.0
	var up_horizontal_scatter: float = 50.0
	var down_horizontal_scatter: float = 100.0
	var drop_duration: float = 0.8
	var up_horizontal_offset = randf_range(-up_horizontal_scatter, up_horizontal_scatter)
	item_instance.position = position
	item_instance.modulate.a = 0
	var tween = create_tween()
	tween.set_parallel(true)
	var rise_position = position + Vector2(
		up_horizontal_offset,
		- max_height
	)
	var down_horizontal_offset = randf_range(-down_horizontal_scatter, down_horizontal_scatter)
	var landing_position = position + Vector2(down_horizontal_offset, 0)
	tween.tween_property(item_instance, "modulate:a", 1.0, drop_duration * 0.2)
	tween.tween_property(item_instance, "position", rise_position, drop_duration * 0.5) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(item_instance, "position", landing_position, drop_duration * 0.5) \
		.set_delay(drop_duration * 0.5) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_IN)
	tween.tween_property(
		item_instance,
		"rotation",
		deg_to_rad(randf_range(360, 720)),
		drop_duration
	).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(item_instance, "scale", Vector2(1.2, 1.2), drop_duration * 0.2)
	tween.chain().tween_property(item_instance, "scale", Vector2(1, 1), drop_duration * 0.1)
	return item_instance

func drop_multiple_items(drop_position: Vector2, item_types: Array, item_count: int = -1) -> void:
	if item_count == -1:
		item_count = item_types.size()
	var drop_items = item_types.duplicate()
	while drop_items.size() < item_count:
		drop_items.append(item_types[randi() % item_types.size()])
	drop_items.shuffle()
	for i in range(min(item_count, drop_items.size())):
		instantiate_item(drop_items[i], drop_position)
