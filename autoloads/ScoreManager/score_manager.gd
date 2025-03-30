extends Control
@onready var coin_score: Label = ScoreUi.get_node('CanvasLayer').get_node('CoinScore')
@onready var gen_score: Label = ScoreUi.get_node('CanvasLayer').get_node('GenScore')
var points = {
	"coin": 30,
	"enemy": 100,
	"powerup": 50,
	"completion": 500
}
var total_score: int = 0
var collected_items = {
	"coin": 0,
	"enemy": 0,
	"powerup": 0,
	"completion": 0,
}
func add_points(item_type: String) -> void:
	match item_type:
		"coin":
			total_score += points["coin"]
			gen_score.text = "Score: " + str(total_score)
			print("total score: ", total_score)
			
			collected_items["coin"] += 1
			coin_score.text = str(collected_items["coin"])
		"enemy":
			total_score += points["enemy"]
			gen_score.text = "Score: " + str(total_score)
			collected_items["enemy"] += 1
		"powerup":
			total_score += points["powerup"]
			gen_score.text = "Score: " + str(total_score)
			collected_items["powerup"] += 1
		"completion":
			gen_score.text = "Score: " + str(total_score)
			total_score += points["completion"]
func reset_score() -> void:
	total_score = 0
	collected_items = {
		"coin": 0,
		"enemy": 0,
		"powerup": 0,
		"completion": 0
	}
	gen_score.text = "Score: 0"
	coin_score.text = "0"
