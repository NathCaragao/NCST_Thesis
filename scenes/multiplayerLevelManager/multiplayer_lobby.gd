extends Control

# RESPONSIBLE FOR:
# - Invoking ServerManager funcs to send data to server
# - Connecting to ServerManager's signals to receive updates from server
# - Storing variables that contains data that subguis' ui elements will use
# - Invoking subguis' funcs to update their UI
# - Connecting to subguis' signals to listen for their events and act accordingly

# CHANGING SUBGUIS:
# - Get the new match state and decide which GUI to show
# - Clear the current showing GUI
# - Load the new GUI
# - Invoke .updateGUI() or similar func to supply initial data to show


# Will help in keeping track the status of multiplayer
enum MatchState {
	NO_MATCH,
	LOBBY_MATCH,
	ONGOING_MATCH
}

# Sub GUIs
@onready var noMatchGUI: NoMatchGUI = %NoMatchGUI
@onready var lobbyMatchGUI: LobbyMatchGUI = %LobbyMatchGUI
@onready var ongoingMatchGUI = %OngoingMatchGUI

# Common Variables between subgui
var joinedMatchID = ""
var currentMatchState:MatchState


# Do all subgui signals connections here and set the initial state
func _ready() -> void:
	noMatchGUI.matchCreated.connect(_handleMatchCreated)
	noMatchGUI.matchJoined.connect(_handleMatchJoined)
	
	lobbyMatchGUI.leftMatch.connect(_handleMatchLeft)
	
	_handleMatchStateStatus(MatchState.NO_MATCH)


func _handleMatchStateStatus(newMatchState:MatchState):
	SceneManager.showLoadingScreen()
	
	if newMatchState == MatchState.NO_MATCH:
		lobbyMatchGUI.hide()
		ongoingMatchGUI.hide()
		noMatchGUI.show()
		
	elif newMatchState == MatchState.LOBBY_MATCH:
		noMatchGUI.hide()
		ongoingMatchGUI.hide()
		
		lobbyMatchGUI.updateJoinedMatchLabel(self.joinedMatchID)
		lobbyMatchGUI.show()
		
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
	_handleMatchStateStatus(currentMatchState)

#------------------------------------------------------------------------------
# LobbyMatchGUI related functions
#------------------------------------------------------------------------------
func _handleMatchLeft() -> void:
	self.joinedMatchID = ""
	currentMatchState = MatchState.LOBBY_MATCH
	_handleMatchStateStatus(currentMatchState)
