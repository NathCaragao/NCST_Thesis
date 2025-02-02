# ScoreManager.gd
extends Control

# labels UI references
@onready var coin_score : Label = ScoreUi.get_node('CanvasLayer').get_node('CoinScore')
@onready var gen_score : Label = ScoreUi.get_node('CanvasLayer').get_node('GenScore')
# Points per item type
var points = {
	"coin" : 30,
	"enemy" : 100,
	"powerup" : 50,
	"completion" : 500
}

# track general score
var total_score : int = 0

# Track collected items
var collected_items = {
	"coin" : 0,
	"enemy" : 0,
	"powerup" : 0,
	"completion" : 0,
}

# Function to add points and update collected items
func add_points(item_type: String) -> void:
	match item_type:
		"coin":
			total_score += points["coin"] # adds to the general score
			gen_score.text = "Score: " + str(total_score) # updates the gen score UI
			print("total score: ", total_score)
			
			collected_items["coin"] += 1 # adds to the amount of coins collected
			coin_score.text = str(collected_items["coin"]) # updates the coin collected UI
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

# Function to reset all scores and collected items to 0
func reset_score() -> void:
	# Reset total score to 0
	total_score = 0
	
	# Reset collected items dictionary to 0
	collected_items = {
		"coin": 0,
		"enemy": 0,
		"powerup": 0,
		"completion": 0
	}
	
	# Update UI labels to reflect reset
	gen_score.text = "Score: 0"
	coin_score.text = "0"
