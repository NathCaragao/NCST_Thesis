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
	SignalsAutoload.requestChangeScene.connect()

# ServerManager related handlers
#	- Auth
func handleRequestEmailAndPassLogin(email : String, password : String):
	# Steps to do:
	# 1. Setup a loading screen
	# 2. Let ServerManager execute the login
	ServerManager.loginWithEmailAndPassword(email, password)
	# 3. Await ServerManager's signal that it finished in its operations
	# 4. Take down loading screen
	
