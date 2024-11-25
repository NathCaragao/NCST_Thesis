extends Panel

@onready var item_display: Sprite2D = $CenterContainer/ItemDisplay
@onready var label: Label = $CenterContainer/Panel/Label
@onready var panel: Panel = $ItemDesc/Panel
# items information references
@onready var item_type: Label = $ItemDesc/Panel/Item_type
@onready var item_name: Label = $ItemDesc/Panel/Item_name
@onready var item_desc: Label = $ItemDesc/Panel/Item_desc
var current_slot : InvSlotAmount = null
@onready var player = get_tree().get_first_node_in_group("Player")
# use window references
@onready var util_window: Panel = $UtilWindow

# Add slot number variable
var slot_number: int = -1

func initialize(slot_idx: int) -> void:
	slot_number = slot_idx
	set_process_input(true)

func _input(_event: InputEvent) -> void:
	# Check if this specific slot's hotkey was pressed
	var action_name = "use_slot_" + str(slot_number + 1)
	if Input.is_action_just_pressed(action_name):
		if current_slot and current_slot.item:
			use_item(current_slot.item)

func update(slot: InvSlotAmount) -> void:
	current_slot = slot
	
	if !slot.item:
		item_display.visible = false
		label.visible = false
	else:
		item_display.visible = true
		item_display.texture = slot.item.texture
		if slot.amount > 1:
			label.visible = true
			label.text = str(slot.amount)
		else:
			label.visible = false

func _on_hover_btn_mouse_entered() -> void:
	if current_slot and current_slot.item:
		update_item_info(current_slot.item)
		panel.visible = true

func _on_hover_btn_mouse_exited() -> void:
	panel.visible = false
	await get_tree().create_timer(2).timeout
	util_window.visible = false

func update_item_info(item: InventoryItem):
	if item:
		item_type.text = item.type
		item_name.text = item.name
		item_desc.text = item.description
	else:
		panel.visible = false
		item_type.text = ""
		item_name.text = ""
		item_desc.text = ""

func use_item(item: InventoryItem) -> void:
	if item != null and item["effect"] != "":
		player.apply_item_effect(item)
		
	# Remove the used item from THIS slot only
	current_slot.amount -= 1
	if current_slot.amount <= 0:
		current_slot.item = null
	update(current_slot)

func _on_use_btn_pressed() -> void:
	if current_slot and current_slot.item:
		use_item(current_slot.item)
	util_window.visible = false

func _on_hover_btn_pressed() -> void:
	if current_slot and current_slot.item:
		util_window.visible = true
