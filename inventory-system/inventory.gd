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

func account_insert(item: GearItem):
	var matching_slots = slots.filter(func(slot): 
		return slot.acc_item != null and slot.acc_item.texture == item.texture
	)

	if !matching_slots.is_empty():
		matching_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.acc_item == null)
		if !empty_slots.is_empty():
			empty_slots[0].acc_item = item
			empty_slots[0].amount = 1
			print("New Gear item inserted successfully")
	update.emit()

func remove(item: GearItem) -> bool:
	var item_slot = slots.find(func(slot): return slot.acc_item == item)
	
	if item_slot != null:
		if item_slot.amount > 1:
			item_slot.amount -= 1
		else:
			item_slot.acc_item = null
			item_slot.amount = 0
		update.emit()
		return true
	else:
		return false

func reset():
	for slot in slots:
		slot.item = null
		slot.amount = 0
	update.emit()
