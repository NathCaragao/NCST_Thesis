# ACCOUNT INVENTORY SLOT
extends Panel

@onready var item_display: Sprite2D = $CenterContainer/ItemDisplay
@onready var label: Label = $CenterContainer/Panel/Label
@onready var panel: Panel = $ItemDesc/Panel
@onready var item_type: Label = $ItemDesc/Panel/Item_type
@onready var item_name: Label = $ItemDesc/Panel/Item_name
@onready var item_desc: Label = $ItemDesc/Panel/Item_desc


# Add slot number variable
var slot_number: int = -1

# Ensure this matches the exact type of slot you're using
# If you have a custom class, replace with your exact class name
var current_slot : InvSlotAmount = null

func _ready() -> void:
	pass

func initialize(slot_idx: int) -> void:
	slot_number = slot_idx
	set_process_input(true)

func update(slot: InvSlotAmount) -> void:
	current_slot = slot
	
	if !slot.acc_item:
		item_display.visible = false
		label.visible = false
	else:
		item_display.visible = true
		item_display.texture = slot.acc_item.texture
		print("Slot Texture:", slot.acc_item.texture)
		label.visible = true
		label.text = str(slot.amount)


func display_item_info(item: GearItem) -> void:
	if item:
		panel.visible = true
		item_type.text = str(item.gear_rarity)
		item_name.text = item.name
		item_desc.text = item.get_stat_string()
	else:
		panel.visible = false
		item_type.text = ""
		item_name.text = ""
		item_desc.text = ""


func transfer_item() -> void:
	# check if user is in the character screen
	if PlayerManager.character_info == true:
		if current_slot and current_slot.acc_item:
			GameSignals.emit_signal("ItemEquipped", current_slot.acc_item)
	
		# remove the item after
		current_slot.amount -= 1
		if current_slot.amount <= 0:
			current_slot.acc_item = null
		update(current_slot)
	else:
		print("Transfering items is not allowed on this scene")


func _on_transfer_btn_pressed() -> void:
	transfer_item()

func _on_item_unequipped(item: GearItem):
	pass


func _on_transfer_btn_mouse_entered() -> void:
	if current_slot and current_slot.acc_item:
		display_item_info(current_slot.acc_item)
		print("Item info hovered")


func _on_transfer_btn_mouse_exited() -> void:
	panel.visible = false
	print("Item info hovered exited")
