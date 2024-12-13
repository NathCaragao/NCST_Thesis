extends Node2D



signal LevelLoaded()
signal CurrentPlayerGameDataUpdate(newCurrentPlayerGameData)
signal CurrentPlayerReachedFinish()
signal BackToLobby()

var isLoaded = false

var currentPlayerCharacter: PlayerHercules = null
var otherPlayersCharacter: Array = []

var timer: float = 0

var finishedPlayers: Array = []
var isFinished: bool = false

func _ready() -> void:
	%EndScreen.hide()

func _physics_process(delta: float) -> void:
	if currentPlayerCharacter == null:
		SceneManager.showLoadingScreen()
	elif otherPlayersCharacter.size() == 0:
		SceneManager.showLoadingScreen()
	else:
		SceneManager.hideLoadingScreen()
		
	timer += delta
	if timer >= float(1.0/10.0) and currentPlayerCharacter != null:
		CurrentPlayerGameDataUpdate.emit(currentPlayerCharacter.playerGameData)
		timer = 0

func update(currentPlayerData, otherPlayersData):
	
	
	#if currentPlayerData != {} && currentPlayerData.isStarted && otherPlayersData.size() >= 1:
	## Loop thru otherPlayers and only set a flag to true if everyone is started.
		#var startLevel = true
		#for otherPlayer in otherPlayersData:
			#if otherPlayer.isStarted == false:
				#startLevel = false
		#if startLevel == true:
			#SceneManager.hideLoadingScreen()
	#else:
		#SceneManager.showLoadingScreen()
		
	_loadCurrentPlayer(currentPlayerData)
	_loadOtherPlayers(otherPlayersData)
	_loadLevel()
	
func _loadLevel():
	if isLoaded == false:
		isLoaded = true
		LevelLoaded.emit()
	else:
		return
		
func _loadCurrentPlayer(currentPlayerData):
	if currentPlayerCharacter != null or currentPlayerData == {}:
		# Update user (since this is done using the Player node itself, there is nothing else needed)
		return
	# Else create new player for this user
	var playerCharacter: PlayerHercules = load("res://scenes/player/player.tscn").instantiate()
	playerCharacter.initialize($SpawnPoint/Spawn1.position, true, currentPlayerData.playerData.nakamaData.userId, currentPlayerData.playerData.displayName)
	%Players.add_child(playerCharacter)
	currentPlayerCharacter = playerCharacter
	
func _loadOtherPlayers(otherPlayersData: Array):
	for otherPlayerFromServer in range(0, otherPlayersData.size()):
		# Instantiate characters
		if otherPlayersCharacter.is_empty():
			#var otherPlayerNewCharacter: MultiplayerPlayer = load("res://scenes/multiplayerPlayer/MultiplayerPlayer.tscn").instantiate()
			var otherPlayerNewCharacter: CharacterBody2D = load("res://scenes/player/player.tscn").instantiate()
			otherPlayerNewCharacter.initialize($SpawnPoint/Spawn1.position, false, otherPlayersData[otherPlayerFromServer].playerData.nakamaData.userId, otherPlayersData[otherPlayerFromServer].playerData.displayName)
			otherPlayersCharacter.append(otherPlayerNewCharacter)
			%Players.add_child(otherPlayerNewCharacter)
		else:
			# Find the user in the array then update them
			for localOtherPlayer in range(0, otherPlayersCharacter.size()):
				if otherPlayersData[otherPlayerFromServer].playerData.nakamaData.userId == otherPlayersCharacter[localOtherPlayer].playerGameData.playerId:
					#Update Player's playerGameData
					otherPlayersCharacter[localOtherPlayer].hud.hide()
					otherPlayersCharacter[localOtherPlayer].updatePlayer(otherPlayersData[otherPlayerFromServer])


func _on_finish_line_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			CurrentPlayerReachedFinish.emit()
			
func endMatch(winnerUsername):
	isFinished = true
	%WinnerLabel.text ="%s finished 1st!" % winnerUsername
	%EndScreen.show()


func _on_back_to_lobby_btn_pressed() -> void:
	BackToLobby.emit()

func removePlayer(playerIdToRemove):
	for n in %Players.get_children():
		if n.playerGameData.playerId == playerIdToRemove:
			n.queue_free()


func _on_zones_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			currentPlayerCharacter.position = $SpawnPoint/Spawn1.position


func _on_zones_2_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			currentPlayerCharacter.position = $SpawnPoint/Spawn2.position


func _on_zones_3_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			currentPlayerCharacter.position = $SpawnPoint/Spawn3.position


func _on_zones_4_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			currentPlayerCharacter.position = $SpawnPoint/Spawn4.position


func _on_zones_5_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			currentPlayerCharacter.position = $SpawnPoint/Spawn5.position


func _on_zones_6_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			currentPlayerCharacter.position = $SpawnPoint/Spawn6.position


func _on_zones_7_body_entered(body: Node2D) -> void:
	if is_instance_of(body, CharacterBody2D):
		if body.playerGameData.playerId == currentPlayerCharacter.playerGameData.playerId:
			currentPlayerCharacter.position = $SpawnPoint/Spawn7.position
