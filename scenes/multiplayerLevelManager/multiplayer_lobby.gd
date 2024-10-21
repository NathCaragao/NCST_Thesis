extends Control

# Should be emitted every state change
signal matchStateChanged(newMatchState:MatchState)

enum MatchState {
	NO_MATCH,
	LOBBY_MATCH,
	ONGOING_MATCH
}

func _ready() -> void:
	ServerManager.matchStateReceived.connect(_handleMatchStateUpdate)
	
# Handles the state variable received during ongoing matches
func _handleMatchStateUpdate(matchStateUpdate:NakamaRTAPI.MatchData):
	pass
