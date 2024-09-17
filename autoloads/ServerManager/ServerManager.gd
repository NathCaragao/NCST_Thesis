extends Node


# Global variables for server-wide operations
const SERVER_KEY : String = "thesisServer"
@onready var serverURL : String = "7350-nathcaragao-nakamaserve-wqsrj0o3ahe.ws-us116.gitpod.io"
@onready var nakamaClient : NakamaClient = Nakama.create_client(SERVER_KEY, serverURL, 443, "https")
@onready var nakamaSession : NakamaSession = null
@onready var nakamaSocket : NakamaSocket = null

#-------------------------------------------------------------------------------
# Auth related ops
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

# Idk the return type
func getUserLoggedInInfo():
	return await nakamaClient.get_account_async(nakamaSession)



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
func connectSocketToServerAsync() -> int:
	# Socket is needed for multiplayer functions
	# no socket should be grounds for halting of operations
	nakamaSocket = await Nakama.create_socket_from(nakamaClient)
	var result: NakamaAsyncResult = await nakamaSocket.connect_async(nakamaSession)
	
	if not result.is_exception():
		nakamaSocket.connect("closed", Callable(self, "_on_NakamaSocket_closed"))
		# Signal when socket connection is lost
		nakamaSocket.closed.connect(_on_NakamaSocket_closed)
		
		# ** Just add more signals as needed
		#nakamaSocket.connect("received_match_presence", Callable(self, "_on_NakamaSocket_received_match_presence"))
		return OK
		
	return ERR_CANT_CONNECT

func _on_NakamaSocket_closed():
	nakamaSocket = null

# TEST
func joinMatch(matchId):
	# RPCs are accessible through the client
	# Get id of world to join
	var world: NakamaAPI.ApiRpc = await _client.rpc_async(_session, "get_world_id")
	if not world.is_exception():
		_world_id = world.payload
		
	# RTAPI is used for Real Time functionalities
	# Try to join a match
	var match_join_result: NakamaRTAPI.Match = await _socket.join_match_async(_world_id)
	if match_join_result.is_exception():
		var exception: NakamaException = match_join_result.get_exception()
		printerr("Error joining match: %s - %s" % [exception.status_code, exception.message])
		return {}
		
	# Once successfully joined, add this player to the list of players
	for presence in match_join_result.presences:
		_presences[presence.user_id] = presence
		
	# Return the updated list of players which includes this player
	return _presences
