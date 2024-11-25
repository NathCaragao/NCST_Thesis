extends Control


@onready var coins_val: Label = $VBoxContainer/HBoxContainer2/CoinsVal
@onready var score_val: Label = $VBoxContainer/HBoxContainer/ScoreVal

func _ready() -> void:
	pass

func update_scores() -> void:
	# Get the  current score from the ScoreManager
	# displays the general score
	score_val.text = str(ScoreManager.total_score)
	# displays the amount of coins collected
	coins_val.text = str(ScoreManager.collected_items["coin"])
	print("scores updated")
	

# retry level button
func _on_retry_level_btn_pressed() -> void:
	get_tree().reload_current_scene()
