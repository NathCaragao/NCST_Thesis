# EQUIMENT UI
extends Control

@onready var inv : Inventory = preload("res://inventory-system/inventories/gear_equip.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	GameSignals.connect("ItemEquipped", Callable(self, "_on_item_transferred"))
	
	inv.update.connect(update_slots)
	update_slots()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _on_item_transferred(item: GearItem):
	# insert the gear in the equipment slot
	inv.account_insert(item)
	# apply the gear stats into player stats
	apply_gear_stats(item)
	GameSignals.emit_signal("GearStatsApplied")


func apply_gear_stats(gear_item: GearItem) -> void:
	# Reset the Player's Stat to BASE STATS
	PlayerManager.reset_to_base_stats()
	
	# Access the autoloaded PlayerManager and update its stats
	
	PlayerManager.player_health += gear_item.hp
	PlayerManager.player_attack += gear_item.atk
	PlayerManager.player_defense += gear_item.def
	PlayerManager.player_move_speed += gear_item.spd
