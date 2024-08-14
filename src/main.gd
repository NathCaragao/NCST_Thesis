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
	ServerManager.loginWithEmailAndPassword(email, password)
