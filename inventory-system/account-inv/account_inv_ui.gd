# ACCOUNT INVENTORY UI
extends Control

# load the account inventory (tres file)
@onready var inv : Inventory = preload("res://inventory-system/inventories/account_inv.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	GameSignals.connect("ItemUnequipped", Callable(self, "_on_item_unequipped"))
	
	inv.update.connect(update_slots)
	update_slots()

#func update_slots():
	#for i in range(min(inv.slots.size(), slots.size())):
		## ensure each 'inv.slots' is unique
		#if inv.slots[i] == null:
			#inv.slots[i] = InvSlotAmount.new()
		#slots[i].update(inv.slots[i])

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("acc_inv_open"):
		visible = !visible


func _on_close_btn_pressed() -> void:
	acc_inv_close()

func acc_inv_close() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Get the screen size
	var screen_size = get_viewport_rect().size
	
	# Animate the window moving from center to bottom
	tween.tween_property(self, "position:y", screen_size.y, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	# After the animation completes, hide the window
	tween.tween_callback(func(): visible = false)

func _on_item_unequipped(item: GearItem):
	inv.account_insert(item)
