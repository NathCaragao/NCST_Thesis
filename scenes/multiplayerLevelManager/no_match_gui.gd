class_name NoMatchGUI
extends CanvasLayer

signal matchCreated(matchCreatedID:String)
signal matchJoined(isPlayerHost:bool)
signal returnToLevelSelector()


func update(gameData):
	# Doesn't need game data, defined just to avoid errors
	pass

func cleanup():
	%MatchIdField.text = ""

func _joinMatch(matchIdToJoin:String, isPlayerHost:bool) -> void:
	var joinResult = await ServerManager.joinMatch(matchIdToJoin)
	if joinResult != OK:
		Notification.showMessage("Failed to Join Match", 3.0)
		return
	matchJoined.emit(isPlayerHost)

func _on_create_match_btn_pressed() -> void:
	var newMatchID = await ServerManager.createMatch()
	if newMatchID == "":
		Notification.showMessage("Failed To Create Match", 3.0)
		return
	matchCreated.emit(newMatchID)
	await _joinMatch(newMatchID, true)

func _on_join_match_btn_pressed() -> void:
	if %MatchIdField.text == "":
		return
	print_debug("MATCH ID TO JOIN: ", %MatchIdField.text)
	matchCreated.emit(%MatchIdField.text)
	await _joinMatch(%MatchIdField.text, false)


func _on_go_back_btn_pressed() -> void:
	returnToLevelSelector.emit()
