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


func _on_hover_btn_mouse_entered() -> void:
	if current_slot and current_slot.acc_item:
		display_item_info(current_slot.acc_item)

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

func _on_hover_btn_mouse_exited() -> void:
	panel.visible = false
