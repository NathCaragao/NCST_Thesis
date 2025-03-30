class_name LobbyMatchGUI
extends CanvasLayer

signal playerReadyStatusChanged()
signal currentPlayerLeftMatch
signal matchCountdownTimeout


func _process(delta: float) -> void:
	if %Timer.is_stopped() == false:
		%Label2.text = "Match is about to start in %s seconds." % floor(%Timer.time_left) 

func update(matchID:String, currentPlayerData, otherPlayersData:Array):
	_updateJoinedMatchIDLabel(matchID)
	_updateCurrentPlayer(currentPlayerData)
	_updateOtherPlayer(otherPlayersData)
	if currentPlayerData != {} && currentPlayerData.isReady && otherPlayersData.size() >= 1:
		
		var startTimer = true
		for otherPlayer in otherPlayersData:
			if otherPlayer.isReady == false:
				startTimer = false
		
		if startTimer && %Timer.is_stopped() == true:
			startTimer()
		elif !startTimer && %Timer.is_stopped() == false:
			stopTimer()
	else:
		stopTimer()
		
func _updateJoinedMatchIDLabel(newJoinedMatchID:String):
	if %JoinedMatchID.text == newJoinedMatchID:
		return
	%JoinedMatchID.text = newJoinedMatchID

func _updateCurrentPlayer(currentPlayer):
	if currentPlayer == {}:
		return
		
	%CurrentPlayerUsername.text = currentPlayer.playerData.displayName
	if currentPlayer.isReady:
		%ReadyBtn.text = "Cancel"
		%LeaveMatchBtn.disabled = true
	else:
		%ReadyBtn.text = "Ready"
		%LeaveMatchBtn.disabled = false

func _updateOtherPlayer(otherPlayers: Array):
	if otherPlayers.size() >= 0:
		%Username1.text = "----------"
		%ReadyStatus1.text = "----------"
		%Username2.text = "----------"
		%ReadyStatus2.text = "----------"
	if otherPlayers.size() >= 1:
		%Username1.text = otherPlayers[0].playerData.displayName
		%ReadyStatus1.text = "READY" if otherPlayers[0].isReady else "NOT READY"
	if otherPlayers.size() >= 2:
		%Username2.text = otherPlayers[1].playerData.displayName
		%ReadyStatus2.text = "READY" if otherPlayers[1].isReady else "NOT READY"

func startTimer():
	%Timer.start(5)
	%MatchCountdown.show()
	
func stopTimer():
	%Timer.stop()
	%MatchCountdown.hide()

func _on_ready_btn_pressed() -> void:
	playerReadyStatusChanged.emit()
	
func _on_leave_match_btn_pressed() -> void:
	currentPlayerLeftMatch.emit()	

func _on_timer_timeout() -> void:
	matchCountdownTimeout.emit()
