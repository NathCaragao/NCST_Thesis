extends Node2D



signal LevelLoaded()
signal CurrentPlayerDirectionChanged(newDirection: Vector2)

var isLoaded = false

var currentPlayerCharacter: PlayerHercules = null
var otherPlayersCharacter: Array = []

var timer: float = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= 0.1:
		CurrentPlayerDirectionChanged.emit(currentPlayerCharacter.direction)
		timer = 0

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
	var playerCamera = Camera2D.new()
	playerCamera.zoom.x = 1.5
	playerCamera.zoom.y = 1.5
	playerCharacter.add_child(playerCamera)
	playerCharacter.position = $SpawnPoint.position
	%Players.add_child(playerCharacter)
	currentPlayerCharacter = playerCharacter
	
func _loadOtherPlayers(otherPlayersData: Array):
	for i in range(0, otherPlayersData.size()):
		# Instantiate characters
		if otherPlayersCharacter.is_empty():
			var otherPlayerNewCharacter = load("res://scenes/multiplayerPlayer/MultiplayerPlayer.tscn").instantiate()
			otherPlayerNewCharacter.position = $SpawnPoint.position
			otherPlayersCharacter.append(otherPlayerNewCharacter)
			%Players.add_child(otherPlayerNewCharacter)
		else:
			# Update things
			pass
