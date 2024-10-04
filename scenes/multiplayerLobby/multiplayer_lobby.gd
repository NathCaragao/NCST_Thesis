extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func initMatch():
	var newMatchID = await ServerManager.createMatch()
	await ServerManager.joinMatch(newMatchID)
	await get_tree().create_timer(10.0).timeout
	await ServerManager.leaveMatch(newMatchID)


func _on_create_match_btn_pressed() -> void:
	initMatch()
