extends Panel

@onready var item_display: Sprite2D = $CenterContainer/ItemDisplay
@onready var label: Label = $CenterContainer/Panel/Label

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
