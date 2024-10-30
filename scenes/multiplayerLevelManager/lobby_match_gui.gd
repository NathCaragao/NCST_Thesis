class_name LobbyMatchGUI
extends CanvasLayer

# PROCESS:
# - JoinedMatchID Label will show the joined match's id
# - whenever player clicks ready button, it will change to Cancel or Ready
# - whenever player receives state updates, it should show other players and their ready status
# - whenever all players are in ready state, a countdown should start and once it reaches 0
#	this gui will send out a signal saying it is good 

# Other players info (might be used for current player):
#{
	#playerInfo: PlayerMultiplayerData
	#username: String
#}

func _ready():
	_updateJoinedMatchIDLabel("TTnaMalaki")
	_updateCurrentPlayer({"username" = "NIGGER", "isReady" = false})
	_updateOtherPlayer([{"username" = "TT", "isReady" = true}, {"username" = "Hard", "isReady" = false}])

signal playerReadyStatusChanged()

func initialize(matchID, gameData):
	_updateJoinedMatchIDLabel(matchID)
	updateGUI(gameData)

func updateGUI(gameData):
	pass

func cleanup():
	pass

func _updateJoinedMatchIDLabel(newJoinedMatchID:String):
	%JoinedMatchID.text = newJoinedMatchID

func _updateCurrentPlayer(currentPlayer):
	%CurrentPlayerUsername.text = currentPlayer.username
	if currentPlayer.isReady:
		%ReadyBtn.text = "Cancel"	
	else:
		%ReadyBtn.text = "Ready"

func _updateOtherPlayer(otherPlayers: Array):
	if otherPlayers.size() >= 0:
		%Username1.text = "----------"
		%ReadyStatus1.text = "----------"
		%Username2.text = "----------"
		%ReadyStatus2.text = "----------"
	if otherPlayers.size() >= 1:
		%Username1.text = otherPlayers[0].username
		%ReadyStatus1.text = "READY" if otherPlayers[0].isReady else "NOT READY"
	if otherPlayers.size() >= 2:
		print_debug("I have come")
		%Username2.text = otherPlayers[1].username
		%ReadyStatus2.text = "READY" if otherPlayers[1].isReady else "NOT READY"

#func _on_ready_btn_pressed() -> void:
	#playerReadyStatusChanged.emit()
	#

#var joinedMatchID:String = ""
#
#var currentUser
#var currentUserDisplayName
#var isCurrentPlayerReady:bool = false
#
#var otherPlayers = []
#
#signal leftMatch
#
#func _ready() -> void:
	#currentUser = await ServerManager.getUserLoggedInInfo()
	#currentUserDisplayName = currentUser.user.display_name
	#
	#updateCurrentPlayer(self.currentUserDisplayName, false)
#
#func _on_leave_match_btn_pressed() -> void:
	#var leaveResult = await ServerManager.leaveMatch(joinedMatchID)
	#if leaveResult != OK:
		#Notification.showMessage("Failed to Leave Match", 3.0)
		#return
	#leftMatch.emit()
		#
#func updateJoinedMatchLabel(newMatchLabel:String) -> void:
	#joinedMatchID = newMatchLabel
	#%JoinedMatchID.text = joinedMatchID
#
#func updateCurrentPlayer(currentPlayerDisplayName:String, isReady:bool):
	#%CurrentPlayerUsername.text = currentPlayerDisplayName
	#if isReady:
		#%ReadyBtn.text = "CANCEL"
	#else:
		#%ReadyBtn.text = "READY"
#
#func updateOtherPlayers():
	#pass
#
