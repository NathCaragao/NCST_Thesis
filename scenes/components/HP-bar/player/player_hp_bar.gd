extends ProgressBar

@onready var dmg_bar: ProgressBar = $DmgBar
@onready var timer: Timer = $Timer
@onready var label: Label = $Label
var health : int = 0 : set = _set_health

func _set_health(new_health) -> void:
	var prev_health = health
	health = min(max_value, new_health)
	
	# Create tween for main health bar
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", health, 0.1)
	
	# Create tween for label
	#var label_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#label_tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1)
	#label_tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.1)
	label.text = str(health)
	
	if health <= 0:
		pass
	
	if health < prev_health:
		timer.start()
	else:
		# Animate damage bar when healing
		var dmg_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		dmg_tween.tween_property(dmg_bar, "value", health, 0.1)

func init_health(_health: int) -> void:
	health = _health
	max_value = health
	value = health
	dmg_bar.max_value = health
	dmg_bar.value = health

func _on_timer_timeout() -> void:
	# Animate damage bar after delay
	var dmg_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	dmg_tween.tween_property(dmg_bar, "value", health, 0.1)
