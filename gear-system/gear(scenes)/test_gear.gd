extends Node2D

@export var gear_data : GearItem
@export var gear_sprite : Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready() -> void:
	# randomize the gear stats
	if gear_data:
		# Randomize stats using GearManager
		GearManager.randomize_gear_stats(gear_data)
		
		# Set the sprite if provided
		if gear_sprite and sprite:
			sprite.texture = gear_sprite
		
		if label:
			label.text = gear_data.get_stat_string()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if player:
		player.acc_collect(gear_data)
		EventNotifier.add_notif("You got a Gear!")
		queue_free()
