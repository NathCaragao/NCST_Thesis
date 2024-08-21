extends Node


# Global variables for server-wide operations
const SERVER_KEY := "thesisServer"
@onready var serverURL := "7350-nathcaragao-nakamaserve-wqsrj0o3ahe.ws-us115.gitpod.io"
@onready var nakamaClient : NakamaClient = Nakama.create_client(SERVER_KEY, serverURL, 443, "https")
@onready var nakamaSession : NakamaSession = null
@onready var nakamaSocket : NakamaSocket = null

# Children references
@onready var Authenticator := %Authentication
@onready var Multiplayer := %Multiplayer

func loginWithEmailAndPassword(email : String, password : String):
	nakamaSession = await Authenticator.loginWithEmailAndPassword(nakamaClient, email, password)
	if nakamaSession == null:
		return FAILED
	else:
		return OK

func registerEmailAndPassword(username : String, email : String, password : String):
	nakamaSession = await Authenticator.registerWithEmailAndPass(nakamaClient, username, email, password)
	if nakamaSession == null:
		return FAILED
	else:
		return OK

# dunno where to put yet
func getCurrentUserInfo():
	return await nakamaClient.get_account_async(nakamaSession)



#-------------------------------------------------
# DB RELATED - will move to "NakamaStorage.gd"
enum ReadPermissions { NO_READ, OWNER_READ, PUBLIC_READ }
enum WritePermissions { NO_WRITE, OWNER_WRITE }

func createUserInDBasync(playerInfo := {}) -> void:
	if nakamaSession == null:
		return
	
	await nakamaClient.write_storage_objects_async(
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

func getUserInfoInDBasync():
	var storage_objects: NakamaAPI.ApiStorageObjects =  await nakamaClient.read_storage_objects_async(
		nakamaSession, 
		[NakamaStorageObjectId.new("playerData", "playerInfo", nakamaSession.user_id)]
	)
	
	if storage_objects.objects:
		var decodedObject = JSON.parse_string(storage_objects.objects[0].value) 
		return decodedObject
	
	return null

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
