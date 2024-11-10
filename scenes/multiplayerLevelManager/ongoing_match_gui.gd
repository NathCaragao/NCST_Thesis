extends Node2D




func _ready() -> void:
	%Camera2D.make_current()
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
	_loadCurrentPlayer()
	_loadOtherPlayers()
	
func _loadLevel():
	if %LevelWorld.get_child_count() == 0:
		%LevelWorld.add_child(preload("res://testFolder/testScenes/multi_test_lvl.tscn").instantiate())
	else:
		return
		
func _loadCurrentPlayer():
	pass
	
func _loadOtherPlayers():
	pass
