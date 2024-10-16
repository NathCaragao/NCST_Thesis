extends Control

enum MatchState {
	NO_MATCH = 1,
	LOBBY_MATCH,
	ONGOING_MATCH
}

@onready var joinedMatchId:String = ""
var currentMatchState: MatchState

@onready var timer: float = 0.0

func _ready() -> void:
	currentMatchState = MatchState.NO_MATCH

func _process(delta: float) -> void:
	timer += delta
	if timer >= 1.0 and joinedMatchId != null:
		print_debug("SENT MSG TO SERVER")
		ServerManager.nakamaSocket.send_match_state_async(joinedMatchId, 1, JSON.stringify({"testKey": 1234}))
		timer = 0

func _initMatch():
	joinedMatchId = await ServerManager.createMatch()
	await ServerManager.joinMatch(joinedMatchId)
	%JoinedMatchID.text = joinedMatchId
	%RoomLobbyGUI.show()
	%NoRoomGUI.hide()
	print_debug('CREATED A MATCH WITH ID: %s', joinedMatchId)


func _on_create_match_btn_pressed() -> void:
	_initMatch()


func _on_join_match_btn_pressed() -> void:
	if %MatchIdField.text != "":
		joinedMatchId = %MatchIdField.text
		await ServerManager.joinMatch(joinedMatchId)

func _on_leave_match_btn_pressed() -> void:
	await ServerManager.leaveMatch(joinedMatchId)
	joinedMatchId = null


#-------------------------------- FSM TEST ---------------------------
