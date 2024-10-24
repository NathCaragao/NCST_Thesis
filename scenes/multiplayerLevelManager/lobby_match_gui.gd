class_name LobbyMatchGUI
extends CanvasLayer

# PROCESS:
# - JoinedMatchID Label will show the joined match's id
# - whenever player clicks ready button, it will change to Cancel or Ready
# - whenever player receives state updates, it should show other players and their ready status
# - whenever all players are in ready state, a countdown should start and once it reaches 0
#	this gui will send out a signal saying it is good 

var joinedMatchID:String = ""

signal playerReadyStatusChanged()

func initialize(gameData:JSON):
	updateGUI(gameData)
	
func updateGUI(gameData:JSON):
	_updateJoinedMatchIDLabel(gameData.joinedMatchID)

func cleanup():
	pass

func _updateJoinedMatchIDLabel(newJoinedMatchID:String):
	self.joinedMatchID = newJoinedMatchID
	%JoinedMatchID.text = self.joinedMatchID

func _on_ready_btn_pressed() -> void:
	playerReadyStatusChanged.emit()
	

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
