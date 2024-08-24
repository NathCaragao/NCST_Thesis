extends Node


# Global variables for server-wide operations
const SERVER_KEY : String = "thesisServer"
@onready var serverURL : String = "7350-nathcaragao-nakamaserve-wqsrj0o3ahe.ws-us115.gitpod.io"
@onready var nakamaClient : NakamaClient = Nakama.create_client(SERVER_KEY, serverURL, 443, "https")
@onready var nakamaSession : NakamaSession = null
@onready var nakamaSocket : NakamaSocket = null

# Children references
@onready var Authenticator : Node = %Authentication
@onready var Multiplayer : Node = %Multiplayer
@onready var storage: Node = $Storage


func loginWithEmailAndPassword(email : String, password : String) -> int:
	nakamaSession = await Authenticator.loginWithEmailAndPassword(nakamaClient, email, password)
	if nakamaSession == null:
		return FAILED
	else:
		return OK

func registerEmailAndPassword(username : String, email : String, password : String) -> int:
	nakamaSession = await Authenticator.registerWithEmailAndPass(nakamaClient, username, email, password)
	if nakamaSession == null:
		return FAILED
	else:
		return OK

# dunno where to put yet
func getCurrentUserInfo():
	return await nakamaClient.get_account_async(nakamaSession)



#-------------------------------------------------


# --------------------------------------------------------
# MULTIPLAYER RELATED - will be moved to "Multiplayer.gd"
func connectSocketToServerAsync() -> int:
	nakamaSocket = await Nakama.create_socket_from(nakamaClient)
	var result: NakamaAsyncResult = await nakamaSocket.connect_async(nakamaSession)
	
	if not result.is_exception():
		nakamaSocket.connect("closed", Callable(self, "_on_NakamaSocket_closed"))
		#nakamaSocket.connect("received_match_presence", Callable(self, "_on_NakamaSocket_received_match_presence"))
		
		return OK
		
	return ERR_CANT_CONNECT

func _on_NakamaSocket_closed():
	nakamaSocket = null

# TEST
func joinMatch(matchId):
	# THIS ONLY WORKS IF THERE IS A CREATED ROOM, ELSE IT WONT WORK
	# THE SERVER-SIDE MUST CREATE A MATCH OR IMPLEMENT A CLIENT-SIDE
	# FUNCTION TO DO THIS
	var match_id = "matchId"
	var joined_match = await nakamaSocket.join_match_async(match_id)

	if joined_match.is_exception():
		print("An error occurred: %s" % joined_match)
		return

	for presence in joined_match.presences:
		print("User id %s name %s'." % [presence.user_id, presence.username])
