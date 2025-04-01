extends Node2D
@export var gear_data : GearItem
@export var gear_sprite : Texture2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var player = get_tree().get_nodes_in_group("Player")[0]
func _ready() -> void:
	var random_rarity = GearItem.Rarity.values()[randi() % GearItem.Rarity.size()]
	gear_data = GearManager.generate_random_gear(random_rarity)
	GearManager.randomize_gear_stats(gear_data)
	gear_data.texture = GearManager.get_random_sprite_for_rarity(gear_data.gear_rarity)
	if sprite:
		sprite.texture = gear_data.texture
	if label:
		label.text = gear_data.get_stat_string()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if player:
		player.acc_collect(gear_data)
		EventNotifier.add_notif("You got a Gear!")
		queue_free()
