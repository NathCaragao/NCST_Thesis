extends Node


# Global variables for server-wide operations
const SERVER_KEY : String = "thesisServer"
const serverURL : String = "7350-nathcaragao-nakamaserve-wqsrj0o3ahe.ws-us116.gitpod.io"
@onready var nakamaClient : NakamaClient = Nakama.create_client(SERVER_KEY, serverURL, 443, "https")
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
func loginWithEmailAndPassword(email : String, password : String) -> int:
	var session = await nakamaClient.authenticate_email_async(email, password, null, false)
	if not session.is_exception():
		nakamaSession = session
		return OK
	else: 
		return FAILED

func registerEmailAndPassword(username : String, email : String, password : String) -> int:
	var session = await nakamaClient.authenticate_email_async(email, password, null, true)
	if not session.is_exception():
		# Change the displayname of user
		var update : NakamaAsyncResult = await nakamaClient.update_account_async(session, username, username, null, null, null)
		nakamaSession = session
		return OK
	else:
		if session.get_exception().grpc_status_code == 16:
			return 1000 # Error for existing account
		return FAILED

func logoutUser() -> void:
	await nakamaClient.session_logout_async(nakamaSession)
	nakamaSession = null

func isUserLoggedIn() -> bool:
	if nakamaSession == null:
		return false
	return true

func getUserLoggedInInfo() -> NakamaAPI.ApiUser:
	var userInfo = await nakamaClient.get_account_async(nakamaSession)
	return userInfo.user



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


#-------------------------------------------------


#-------------------------------------------------------------------------------
# MULTIPLAYER RELATED
#-------------------------------------------------------------------------------
func createMatch(matchName:String = "") -> String:
	if nakamaSocket == null:
		await createSocketAsync()

	var result = await nakamaSocket.rpc_async("createMatchRPC")
	print_debug("CREATED MATCH: %s", result)
	return JSON.parse_string(result.payload)["matchId"]
	

func joinMatch(matchId:String) -> void:
	if nakamaSocket == null:
		await createSocketAsync()
	
	# Try joining a match - this will trigger JoinMatchAttempt func in the server side
	var match_join_result: NakamaRTAPI.Match = await nakamaSocket.join_match_async(matchId)
	
	# Error joining match
	if match_join_result.is_exception():
		var exception: NakamaException = match_join_result.get_exception()
		printerr("Error joining match: %s - %s" % [exception.status_code, exception.message])
		return
		
	# Successfully joined a match - JoinMatch in the server side triggered
	print_debug("Match join result: %s", match_join_result)
	
func leaveMatch(matchId:String) -> void:
	var leaveResult : NakamaAsyncResult = await nakamaSocket.leave_match_async(matchId)
	if leaveResult.is_exception():
		print_debug("An error occurred: %s" % leaveResult)
		return
	print_debug("Match left")

func _on_match_state_received(p_state : NakamaRTAPI.MatchData):
	print_debug("Received match state with opcode %s, data %s" % [p_state.op_code, p_state.data])
