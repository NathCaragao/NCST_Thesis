extends Control

# RESPONSIBLE FOR:
# - Invoking ServerManager funcs to send data to server
# - Connecting to ServerManager's signals to receive updates from server
# - Storing variables that contains data that subguis' ui elements will use
# - Invoking subguis' funcs to update their UI
# - Connecting to subguis' signals to listen for their events and act accordingly
# TLDR: THIS FILE WILL BE BOTH THE MODEL AND CONTROLLER FOR ALL OF ITS GUIs



enum MatchState {
	NO_MATCH,
	LOBBY_MATCH,
	ONGOING_MATCH
}

# Sub GUIs path
@onready var noMatchGUI = %NoMatchGUI
@onready var lobbyMatchGUI = %LobbyMatchGUI
@onready var ongoingMatchGUI = %OngoingMatchGUI

# Common Variables between subgui
var currentGUI = null
var joinedMatchID:String = ""
var currentMatchState:MatchState
@onready var currentPlayer = await ServerManager.getUserLoggedInInfo()
var currentGameState = null
var otherPlayers: Array = []


func _switchGUI(currentGUI, newGUI) -> void:
	if currentGUI == null:
		newGUI.show()
	else:
		currentGUI.hide()
		currentGUI.cleanup()
		newGUI.show()

# Do all subgui signals connections here and set the initial state
func _ready() -> void:
	# Signal connection for noMatchGUI
	noMatchGUI.matchCreated.connect(_handleMatchCreated)
	noMatchGUI.matchJoined.connect(_handleMatchJoined)
	
	# Signal connection for lobbyMatchGUI
	lobbyMatchGUI.playerReadyStatusChanged.connect(_handlePlayerReadyStatusChanged)
	lobbyMatchGUI.currentPlayerLeftMatch.connect(_handleCurrentPlayerLeftMatch)
	
	# Signal from ServerManager
	ServerManager.matchStateReceived.connect(_handleGameStateUpdate)
	
	# Initial Match State initialization
	_handleMatchStateChange(MatchState.NO_MATCH)
	

func _handleGameStateUpdate(gameState:NakamaRTAPI.MatchData):
	#if gameState.op_code == ServerManager.MessageOpCode.DATA_FROM_SERVER: might be unnecessary
	self.currentGameState = JSON.parse_string(gameState.data)
	
	# Separate this player's data from other players
	var otherPlayerData:Array = []
	for presenceId in self.currentGameState.presences:
		if presenceId != self.currentPlayer.user.id:
			otherPlayerData.append(self.currentGameState.presences[presenceId])
	otherPlayerData.sort()
	
	if currentMatchState == MatchState.LOBBY_MATCH:
		pass
		lobbyMatchGUI.update(self.joinedMatchID, currentGameState.presences[self.currentPlayer.user.id], otherPlayerData)
		
# CHANGING SUBGUIS:
# - Get the new match state and decide which GUI to show - done
# - Clear the current showing GUI - done in _switchtGUI
# - Load the new GUI - done in _switchtGUI
# - Invoke .updateGUI() or similar func to supply initial data to show - will be called separately

func _handleMatchStateChange(newMatchState:MatchState):
	SceneManager.showLoadingScreen()
	self.currentMatchState = newMatchState
	
	if newMatchState == MatchState.NO_MATCH:
		_switchGUI(currentGUI, noMatchGUI)
		currentGUI = noMatchGUI
		noMatchGUI.update(null)
		
	elif newMatchState == MatchState.LOBBY_MATCH:
		_switchGUI(currentGUI, lobbyMatchGUI)
		currentGUI = lobbyMatchGUI
		lobbyMatchGUI.update(joinedMatchID, {}, [])
		
	elif newMatchState == MatchState.ONGOING_MATCH:
		pass
		
	SceneManager.hideLoadingScreen()

	
#------------------------------------------------------------------------------
# NoMatchGUI related functions
#------------------------------------------------------------------------------
func _handleMatchCreated(createdMatchID:String):
	self.joinedMatchID = createdMatchID

func _handleMatchJoined(isPlayerHost:bool):
	# If player is host, send a update to server
	var isHostPayload = {
		"userId" = self.currentPlayer.user.id,
		"payload" = {"isHost": isPlayerHost}
	}
	# Send the user's display_name to server
	var displayNamePayload = {
		"userId" = self.currentPlayer.user.id,
		"payload" = {"displayName": self.currentPlayer.user.display_name}
	}
	
	await ServerManager.sendMatchState(self.joinedMatchID, ServerManager.MessageOpCode.UPDATE_HOST, isHostPayload)
	await ServerManager.sendMatchState(self.joinedMatchID, ServerManager.MessageOpCode.UPDATE_DISPLAY_NAME, displayNamePayload)
	_handleMatchStateChange(MatchState.LOBBY_MATCH)
#
##------------------------------------------------------------------------------
## LobbyMatchGUI related functions
##------------------------------------------------------------------------------
#func _handleMatchLeft() -> void:
	#self.joinedMatchID = ""
	#currentMatchState = MatchState.LOBBY_MATCH
	#_handleMatchStateStatus(currentMatchState)
	
func _handlePlayerReadyStatusChanged() -> void:
	# SEND OUT DATA THAT ACCESS THE GAME STATE JSON AND REVERSING THE CURRENT isReady value
	var readyStatusChangePayload = {
		"userId" = self.currentPlayer.user.id,
		"payload" = {"isReady": !self.currentGameState.presences[currentPlayer.user.id].isReady}
	}
	await ServerManager.sendMatchState(self.joinedMatchID, ServerManager.MessageOpCode.LOBBY_PLAYER_READY_CHANGED, readyStatusChangePayload)

func _handleCurrentPlayerLeftMatch():
	var leaveResult = await ServerManager.leaveMatch(joinedMatchID)
	if leaveResult != OK:
		Notification.showMessage("Failed to Leave Match", 3.0)
		return
