class_name Inventory
extends Resource

@export var slots : Array[InvSlotAmount]

signal update

# for inserting consumable items to hotbar
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
	var item_slots = slots.filter(func(slot): return slot.acc_item == item)
	if !item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].acc_item = item
			empty_slots[0].amount = 1
			print("Item Gear collected successfully")
	update.emit()

#func account_insert(item: GearItem):
	## First, check if the same gear item already exists in inventory
	#var matching_slots = acc_slots.filter(func(slot): 
		#return slot.item is GearItem and slot.item.name == item.name
	#)
	#
	#if !matching_slots.is_empty():
	 ## If a matching slot exists, increase its amount
		#matching_slots[0].amount += 1
	#else:
		## Find first empty slot
		#var empty_slots = acc_slots.filter(func(slot): return slot.item == null)
		#
		#if !empty_slots.is_empty():
			## Set the first empty slot with the new gear item
			#empty_slots[0].item = item
			#empty_slots[0].amount = 1
			#print("Gear Item successfully inserted")
		#else:
			## Optional: Handle inventory full scenario
			#print("Inventory is full. Cannot add more items.")
		#
	## Emit update signal to refresh UI
	#update.emit()


# resets the inventory
func reset():
	for slot in slots:
		slot.item = null
		slot.amount = 0
	update.emit()
