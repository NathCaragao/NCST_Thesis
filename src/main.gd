extends Node

@onready var ServerManager = $ServerManager
@onready var MusicManager = $MusicManager
@onready var SceneManager = $SceneManager


func _ready():
	connectToSignals()

func connectToSignals():
	# ServerManager related signals
	#	- Auth
	SignalsAutoload.requestEmailAndPassLogin.connect(handleRequestEmailAndPassLogin)
	# SceneManager related signals
	#SignalsAutoload.requestChangeScene.connect()

# ServerManager related handlers
#	- Auth
func handleRequestEmailAndPassLogin(email : String, password : String):
	# Steps to do:
	# 1. Setup a loading screen
	# -------------
	# 2. Let ServerManager execute the login
	var result = await ServerManager.loginWithEmailAndPassword(email, password)
	# 3. Get the result of the login operation
	if result == OK:
		# Show success notification then change screeen to lobby
		pass
	else:
		# Show failed notification and retain login screen
		pass
	# 4. Take down loading screen
	# ---------------
	
