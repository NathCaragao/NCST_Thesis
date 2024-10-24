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
var currentMatchState:MatchState
#var joinedMatchID = ""
#var currentMatchState:MatchState


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
	
	# Initial Match State initialization
	_handleMatchStateChange(MatchState.NO_MATCH)
	



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
		pass
		#noMatchGUI.hide()
		#ongoingMatchGUI.hide()
		#
		#lobbyMatchGUI.updateJoinedMatchLabel(self.joinedMatchID)
		#lobbyMatchGUI.show()
		
	elif newMatchState == MatchState.ONGOING_MATCH:
		pass
		
	SceneManager.hideLoadingScreen()

	
#------------------------------------------------------------------------------
# NoMatchGUI related functions
#------------------------------------------------------------------------------
func _handleMatchCreated(createdMatchID:String):
	self.joinedMatchID = createdMatchID

func _handleMatchJoined():
	currentMatchState = MatchState.LOBBY_MATCH
	_handleMatchStateChange(currentMatchState)
#
##------------------------------------------------------------------------------
## LobbyMatchGUI related functions
##------------------------------------------------------------------------------
#func _handleMatchLeft() -> void:
	#self.joinedMatchID = ""
	#currentMatchState = MatchState.LOBBY_MATCH
	#_handleMatchStateStatus(currentMatchState)
