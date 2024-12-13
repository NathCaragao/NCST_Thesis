# ACCOUNT INVENTORY UI
extends Control

# load the account inventory (tres file)
@onready var inv : Inventory = preload("res://inventory-system/inventories/account_inv.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	## Initialize each slot with its index
	#for i in range(slots.size()):
		#slots[i].initialize(i)
	
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
