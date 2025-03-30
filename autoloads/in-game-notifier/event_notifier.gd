extends CanvasLayer
@onready var desc: Label = $Desc
var notification_spacing: int = 30
var active_notifications: Array = []
func _ready() -> void:
	visible = false
	desc.visible = false
func add_notif(text: String) -> void:
	var new_desc = desc.duplicate() as Label
	add_child(new_desc)
	visible = true
	new_desc.text = text
	new_desc.visible = true
	new_desc.modulate.a = 0
	new_desc.position.x = desc.position.x - 50  	
	var y_offset = active_notifications.size() * notification_spacing
	new_desc.position.y = desc.position.y + y_offset
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(new_desc, "modulate:a", 1.0, 0.3)
	tween.tween_property(new_desc, "position:x", desc.position.x, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	active_notifications.append(new_desc)
	handle_notification_timeout(new_desc)
func handle_notification_timeout(notification: Label) -> void:
	await get_tree().create_timer(2.7).timeout  	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(notification, "modulate:a", 0.0, 0.3)
	tween.tween_property(notification, "position:x", notification.position.x + 50, 0.3)  
	await tween.finished 
	notification.queue_free()
	active_notifications.erase(notification)
	if active_notifications.is_empty():
		visible = false
	else:
		update_notification_positions()
func update_notification_positions() -> void:
	for i in range(active_notifications.size()):
		var notification = active_notifications[i]
		var target_pos = desc.position + Vector2(0, i * notification_spacing)
		var tween = create_tween()
		tween.tween_property(notification, "position:y", target_pos.y, 0.2).set_ease(Tween.EASE_OUT)
