extends Control

# RESPONSIBLE FOR:
# - Invoking ServerManager funcs to send data to server
# - Connecting to ServerManager's signals to receive updates from server
# - Storing variables that contains data that subguis' ui elements will use
# - Invoking subguis' funcs to update their UI
# - Connecting to subguis' signals to listen for their events and act accordingly



# Will help in keeping track the status of multiplayer
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

var currentGameState = JSON.parse_string("{
	\"presences\": {},
}")



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
	
	# Signal from ServerManager
	ServerManager.matchStateReceived.connect(_handleGameStateUpdate)
	# Initial Match State initialization
	_handleMatchStateChange(MatchState.NO_MATCH)
	

func _handleGameStateUpdate(gameState:NakamaRTAPI.MatchData):
	if gameState.op_code == 99:
		currentGameState = JSON.parse_string(gameState.data)
		print_debug("UPDATED GAME STATE")
		
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
		noMatchGUI.initialize(null)
		
	elif newMatchState == MatchState.LOBBY_MATCH:
		_switchGUI(currentGUI, lobbyMatchGUI)
		currentGUI = lobbyMatchGUI
		lobbyMatchGUI.initialize(joinedMatchID, currentGameState)
		
	elif newMatchState == MatchState.ONGOING_MATCH:
		pass
		
	SceneManager.hideLoadingScreen()

	
#------------------------------------------------------------------------------
# NoMatchGUI related functions
#------------------------------------------------------------------------------
func _handleMatchCreated(createdMatchID:String):
	self.joinedMatchID = createdMatchID

func _handleMatchJoined():
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
	# GET PLAYER USER ID
	var currentPlayerID = currentPlayer.user.id
	# SEND OUT DATA THAT ACCESS THE GAME STATE JSON AND REVERSING THE CURRENT isReady value
	var matchID = self.joinedMatchID
	var msgCode = ServerManager.MessageOpCode.LOBBY_READY_UPDATE
	var payload = {
		"userID" = currentPlayerID,
		"isReady" = !currentGameState.presences[currentPlayerID].isReady
	}
	await ServerManager.sendMatchState(matchID, msgCode, payload)
