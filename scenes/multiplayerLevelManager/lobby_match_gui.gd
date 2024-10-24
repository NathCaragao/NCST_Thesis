class_name LobbyMatchGUI
extends CanvasLayer


var joinedMatchID:String = ""

var currentUser
var currentUserDisplayName
var isCurrentPlayerReady:bool = false

var otherPlayers = []

signal leftMatch

func _ready() -> void:
	currentUser = await ServerManager.getUserLoggedInInfo()
	currentUserDisplayName = currentUser.user.display_name
	
	updateCurrentPlayer(self.currentUserDisplayName, false)

func _on_leave_match_btn_pressed() -> void:
	var leaveResult = await ServerManager.leaveMatch(joinedMatchID)
	if leaveResult != OK:
		Notification.showMessage("Failed to Leave Match", 3.0)
		return
	leftMatch.emit()
		
func updateJoinedMatchLabel(newMatchLabel:String) -> void:
	joinedMatchID = newMatchLabel
	%JoinedMatchID.text = joinedMatchID

func updateCurrentPlayer(currentPlayerDisplayName:String, isReady:bool):
	%CurrentPlayerUsername.text = currentPlayerDisplayName
	if isReady:
		%ReadyBtn.text = "CANCEL"
	else:
		%ReadyBtn.text = "READY"

func updateOtherPlayers():
	pass

func _on_ready_btn_pressed() -> void:
	isCurrentPlayerReady = !isCurrentPlayerReady
	await ServerManager.sendMatchState(joinedMatchID, ServerManager.MessageOpCode.LOBBY_READY_UPDATE, {"isReady": self.isCurrentPlayerReady})
