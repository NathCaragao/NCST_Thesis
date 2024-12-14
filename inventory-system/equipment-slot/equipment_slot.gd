extends Panel

@onready var sprite: Sprite2D = $Sprite2D
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
		label.visible = true
		label.text = str(slot.amount)
		#if slot.amount > 1:
			#label.visible = true
			#label.text = str(slot.amount)
		#else:
			#label.visible = false

func transfer_item() -> void:
	if current_slot and current_slot.acc_item:
		GameSignals.emit_signal("ItemUnequipped", current_slot.acc_item)
	
	# remove the item after
	current_slot.amount -= 1
	if current_slot.amount <= 0:
		current_slot.acc_item = null
	update(current_slot)


func _on_transfer_btn_pressed() -> void:
	transfer_item()
