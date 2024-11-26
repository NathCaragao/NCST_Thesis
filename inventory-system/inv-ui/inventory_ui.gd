extends Control

var is_open : bool = false
# player's inv
@onready var inv : Inventory = preload("res://inventory-system/inventories/player_inv.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	# Initialize each slot with its index
	for i in range(slots.size()):
		slots[i].initialize(i)
	
	inv.update.connect(update_slots)
	update_slots()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open-inv"):
		visible = !visible # opens and close the inv like a light switch
