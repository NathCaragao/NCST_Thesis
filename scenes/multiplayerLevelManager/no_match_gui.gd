class_name NoMatchGUI
extends CanvasLayer

signal matchCreated(matchCreatedID:String)
signal matchJoined()


func initialize(gameData):
	# Doesn't need game data, defined just to avoid errors
	pass

func cleanup():
	%MatchIdField.text = ""

func _joinMatch(matchIdToJoin:String) -> void:
	var joinResult = await ServerManager.joinMatch(matchIdToJoin)
	if joinResult != OK:
		Notification.showMessage("Failed to Join Match", 3.0)
		return
	matchJoined.emit()

func _on_create_match_btn_pressed() -> void:
	var newMatchID = await ServerManager.createMatch()
	if newMatchID == "":
		Notification.showMessage("Failed To Create Match", 3.0)
		return
	matchCreated.emit(newMatchID)
	
	await _joinMatch(newMatchID)

func _on_join_match_btn_pressed() -> void:
	if %MatchIdField.text == "":
		return
	matchCreated.emit(%MatchIdField.text)
	await _joinMatch(%MatchIdField.text)
