extends Node


# Global variables for server-wide operations
const SERVER_KEY : String = "TheousKai"
# THIS IS THE CLOUD SERVER
#const serverURL : String = "7350-nathcaragao-nakamaserve-wqsrj0o3ahe.ws-us116.gitpod.io"
#@onready var nakamaClient : NakamaClient = Nakama.create_client(SERVER_KEY, serverURL, 443, "https")
# THIS IS THE LOCAL SERVER
const serverURL : String = "127.0.0.1"
@onready var nakamaClient : NakamaClient = Nakama.create_client(SERVER_KEY, serverURL, 7350, "http")
@onready var nakamaSession : NakamaSession = null
@onready var nakamaSocket : NakamaSocket = null

# Subcomponents
@onready var Auth = Authentication.new()



func createSocketAsync() -> int:
	# Socket is needed for multiplayer functions
	# no socket should be grounds for halting of operations
	nakamaSocket = await Nakama.create_socket_from(nakamaClient)
	var result: NakamaAsyncResult = await nakamaSocket.connect_async(nakamaSession)
	
	if not result.is_exception():
		nakamaSocket.connect("closed", Callable(self, "_on_NakamaSocket_closed"))
		# Signal when socket connection is lost
		nakamaSocket.closed.connect(_on_NakamaSocket_closed)
		nakamaSocket.received_match_state.connect(_on_match_state_received)
		# ** Just add more signals as needed
		return OK
		
	return ERR_CANT_CONNECT

func _on_NakamaSocket_closed():
	nakamaSocket = null


#-------------------------------------------------------------------------------
# Auth related ops - related to session
#-------------------------------------------------------------------------------
func loginWithEmailAndPassword(email: String, password: String) -> int:
	var loginResult = await Auth.loginWithEmailAndPassword(self.nakamaClient, email, password)
	if loginResult != null:
		self.nakamaSession = loginResult
		return OK
	else: 
		return FAILED

func registerEmailAndPassword(username: String, email: String, password: String) -> int:
	var isEmailExisting = await Auth.isEmailAlreadyExisting(self.nakamaClient, email)
	if isEmailExisting == true:
		return 1000
		
	var registerResult = await Auth.registerEmailAndPassword(self.nakamaClient, username, email, password)
	if registerResult != null:
		self.nakamaSession = registerResult
		return OK
	else:
		return FAILED

func logoutUser() -> int:
	var logoutResult = await Auth.logoutUser(self.nakamaClient, self.nakamaSession)
	if logoutResult == OK:
		nakamaSession = null
		return OK
	else:
		return FAILED

func isUserLoggedIn() -> bool:
	return await Auth.isUserLoggedIn(self.nakamaSession)

func getUserLoggedInInfo():
	var userInfoResult = await Auth.getUserLoggedInInfo(self.nakamaClient, self.nakamaSession)
	if userInfoResult == null:
		return null
	else:
		return userInfoResult

func getUserInfoFromID(userID:String):
	var result: NakamaAPI.ApiUsers = await nakamaClient.get_users_async(nakamaSession, [userID])
	var userInfo
	for info in result.users:
		userInfo = info
		
	return userInfo

#-------------------------------------------------------------------------------
# Storage related ops
#-------------------------------------------------------------------------------
enum ReadPermissions { NO_READ, OWNER_READ, PUBLIC_READ }
enum WritePermissions { NO_WRITE, OWNER_WRITE }

func addUserInDB() -> int:
	# no user is logged in yet
	if nakamaSession == null:
		return FAILED
	
	# create user info in DB and store it
	var result = await nakamaClient.write_storage_objects_async(
		nakamaSession,
		[
			NakamaWriteStorageObject.new(
				"playerData",
				"playerInfo",
				ReadPermissions.OWNER_READ,
				WritePermissions.OWNER_WRITE,
				JSON.stringify(
					{
						freeCurrency = 0,
						premiumCurrency = 0,
						skins = [],
						characters = [],
						latestCompletedLevel = "",
						equipmentInventory = [],
						itemsInventory = [],
						settings = [],
					}
				),
				""
			)
		]
	)
	
	if result != null:
		return OK
	else:
		return FAILED
	

#func getUserInfoInDBasync():
	#var storage_objects: NakamaAPI.ApiStorageObjects =  await nakamaClient.read_storage_objects_async(
		#nakamaSession, 
		#[NakamaStorageObjectId.new("playerData", "playerInfo", nakamaSession.user_id)]
	#)
	#
	#if storage_objects.objects:
		#var decodedObject = JSON.parse_string(storage_objects.objects[0].value) 
		#return decodedObject
	#
	#return null

# Update this, might be better to break it to several individual functions
# updateUserFreeCurrency, updateUserPremiumCurrency, etc.
#func updateUserInfoInDBasync(keyToUpdate, value):
	#var currentUserInfo = await getUserInfoInDBasync()
	#
	#if currentUserInfo.has(keyToUpdate):
		#var existing_value = currentUserInfo[keyToUpdate]
		#
		#if typeof(existing_value) == TYPE_FLOAT or typeof(existing_value) == TYPE_INT:
			## If it's a float or int, add or subtract the value
			#currentUserInfo[keyToUpdate] += value
		#elif typeof(existing_value) == TYPE_ARRAY:
			## If it's an array, handle JSON objects within the array
			#for entry in value:
				#var found = false
				## Loop over the items in DB, but no way to add multiple items from arg yet
				#for item in existing_value:
					#var keysInValue = entry.keys()
					#if item.has(keysInValue[0]):
						#item[keysInValue[0]] += entry[keysInValue[0]]
						#found = true
						#break
				#if not found:
					#existing_value.append(entry)
	#else:
		## If the key does not exist, initialize it appropriately
		#if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
			#currentUserInfo[keyToUpdate] = value
		#elif typeof(value) == TYPE_ARRAY:
			#currentUserInfo[keyToUpdate] = [value]
#
	##print_debug(currentUserInfo)
	## Optionally, update the server with the new user info if needed
	#await _client.write_storage_objects_async(
		#_session,
		#[
			#NakamaWriteStorageObject.new(
				#"playerData",
				#"playerInfo",
				#ReadPermissions.OWNER_READ,
				#WritePermissions.OWNER_WRITE,
				#JSON.stringify(currentUserInfo),
				#""
			#)
		#]
	#)



#-------------------------------------------------------------------------------
# MULTIPLAYER RELATED
#-------------------------------------------------------------------------------
enum MessageOpCode {
  DATA_FROM_SERVER = 1,
  UPDATE_DISPLAY_NAME,
  UPDATE_HOST,
  LOBBY_PLAYER_READY_CHANGED,
  ONGOING_PLAYER_STARTED_CHANGED,
  ONGOING_PLAYER_DATA_UPDATE,
}

signal matchStateReceived(matchState: NakamaRTAPI.MatchData)

func createMatch(matchName:String = "") -> String:
	if nakamaSocket == null:
		await createSocketAsync()

	var result = await nakamaSocket.rpc_async("createMatchRPC")
	print_debug("CREATED MATCH: %s", result)
	return JSON.parse_string(result.payload)["matchId"]
	

func joinMatch(matchId:String) -> int:
	if nakamaSocket == null:
		await createSocketAsync()
	
	# Try joining a match - this will trigger JoinMatchAttempt func in the server side
	var match_join_result: NakamaRTAPI.Match = await nakamaSocket.join_match_async(matchId)
	
	# Error joining match
	if match_join_result.is_exception():
		var exception: NakamaException = match_join_result.get_exception()
		printerr("Error joining match: %s - %s" % [exception.status_code, exception.message])
		return FAILED
		
	# Successfully joined a match - JoinMatch in the server side triggered
	print_debug("Match join result: %s", match_join_result)
	return OK
	
func leaveMatch(matchId:String) -> int:
	var leaveResult : NakamaAsyncResult = await nakamaSocket.leave_match_async(matchId)
	if leaveResult.is_exception():
		print_debug("An error occurred: %s" % leaveResult)
		return FAILED
	print_debug("Match left")
	return OK

func sendMatchState(matchId:String, messageOpCode:MessageOpCode, message:Dictionary) -> void:
	await nakamaSocket.send_match_state_async(matchId, messageOpCode, JSON.stringify(message))


func _on_match_state_received(p_state : NakamaRTAPI.MatchData):
	#print_debug("Received match state with opcode %s, data %s" % [p_state.op_code, p_state.data])
	# p_state.data is type string.
	matchStateReceived.emit(p_state)
