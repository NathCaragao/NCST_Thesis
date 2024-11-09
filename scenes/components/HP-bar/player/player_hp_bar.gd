class_name PlayerHealthBar
extends ProgressBar

# references and variables
@onready var dmg_bar: ProgressBar = $DmgBar
@onready var timer: Timer = $Timer
@onready var label: Label = $Label

var health : int = 0 : set = _set_health

func _set_health(new_health) -> void:
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	label.text = str(health)
	
	if health <= 0:
		pass
	
	if health < prev_health:
		timer.start()
	else:
		dmg_bar.value = health

func init_health(_health: int) -> void:
	health = _health
	max_value = health
	value = health
	dmg_bar.max_value = health
	dmg_bar.value = health


func _on_timer_timeout() -> void:
	dmg_bar.value = health
