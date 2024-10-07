extends Control

@onready var userInfo = await ServerManager.getUserLoggedInInfo()
@onready var joinedMatchId = null

@onready var timer: float = 0.0

func _ready() -> void:
	%RoomLobbyGUI.hide()

func _process(delta: float) -> void:
	timer += delta
	print_debug(timer)

func initMatch():
	var joinedMatchId = await ServerManager.createMatch()
	await ServerManager.joinMatch(joinedMatchId)
	%JoinedMatchID.text = joinedMatchId
	%RoomLobbyGUI.show()
	%NoRoomGUI.hide()


func _on_create_match_btn_pressed() -> void:
	initMatch()
