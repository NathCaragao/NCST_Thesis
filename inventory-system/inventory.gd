class_name Inventory
extends Resource

@export var slots : Array[InvSlotAmount]

signal update

func insert(item: InventoryItem):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	update.emit()

# resets the inventory
func reset():
	for slot in slots:
		slot.item = null
		slot.amount = 0
	update.emit()
