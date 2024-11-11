extends Node2D



signal LevelLoaded()

var isLoaded = false

var currentPlayerCharacter = null
var otherPlayersCharacter: Array = []

func _ready() -> void:
	pass

func update(currentPlayerData, otherPlayersData):
	if currentPlayerData != {} && currentPlayerData.isStarted && otherPlayersData.size() >= 1:
	# Loop thru otherPlayers and only set a flag to true if everyone is started.
		var startLevel = true
		for otherPlayer in otherPlayersData:
			if otherPlayer.isStarted == false:
				startLevel = false
		if startLevel	== true:
			SceneManager.hideLoadingScreen()
	else:
		SceneManager.showLoadingScreen()
		
	_loadLevel()
	_loadCurrentPlayer(currentPlayerData)
	_loadOtherPlayers(otherPlayersData)
	
func _loadLevel():
	if isLoaded == false:
		isLoaded = true
		LevelLoaded.emit()
	else:
		return
		
func _loadCurrentPlayer(currentPlayerData):
	if currentPlayerCharacter != null:
		return
		
	var playerCharacter = load("res://scenes/player/player.tscn").instantiate()
	playerCharacter.add_child(Camera2D.new())
	playerCharacter.position = $SpawnPoint.position
	%Players.add_child(playerCharacter)
	currentPlayerCharacter = playerCharacter
	
func _loadOtherPlayers(otherPlayersData: Array):
	for i in range(0, otherPlayersData.size()):
		# Instantiate characters
		if otherPlayersCharacter.is_empty():
			var otherPlayerNewCharacter = load("res://scenes/multiplayerPlayer/MultiplayerPlayer.tscn").instantiate()
			otherPlayersCharacter.append(otherPlayerNewCharacter)
			%Players.add_child(otherPlayerNewCharacter)
		else:
			# Update things
			pass
