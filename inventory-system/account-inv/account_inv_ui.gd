extends Control

@onready var inv : Inventory = preload("res://inventory-system/inventories/account_inv.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	GameSignals.connect("ItemUnequipped", Callable(self, "_on_item_unequipped"))
	
	inv.update.connect(update_slots)
	update_slots()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("acc_inv_open"):
		visible = !visible


func _on_close_btn_pressed() -> void:
	acc_inv_close()

func acc_inv_close() -> void:
	var tween = create_tween()
	
	var screen_size = get_viewport_rect().size
	
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	tween.tween_callback(func(): visible = false)

func _on_item_unequipped(item: GearItem):
	inv.account_insert(item)
	remove_gear_stats(item)
	GameSignals.emit_signal("GearStatsRemoved")

func remove_gear_stats(gear_item: GearItem) -> void:
	PlayerManager.reset_to_base_stats()
	
	PlayerManager.player_health -= gear_item.hp
	PlayerManager.player_attack -= gear_item.atk
	PlayerManager.player_defense -= gear_item.def
	PlayerManager.player_move_speed -= gear_item.spd
	
