extends Node


# KEEP THESE HERE, LET SUBFILES ACCESS IT THROUGH THIS FILE ONLY
const SERVER_KEY := "thesisServer"
@onready var _client : NakamaClient = Nakama.create_client(SERVER_KEY, "7350-nathcaragao-nakamaserve-iu5ff8h7h91.ws-us115.gitpod.io", 443, "https")
@onready var _session : NakamaSession = null
@onready var _socket : NakamaSocket = null

func getUser():
	return await _client.get_account_async(_session)
	
	
#-------------------------------------------------
# DB RELATED
enum ReadPermissions { NO_READ, OWNER_READ, PUBLIC_READ }
enum WritePermissions { NO_WRITE, OWNER_WRITE }

func createUserInDBasync(playerInfo := {}) -> void:
	if _session == null:
		return
	
	await _client.write_storage_objects_async(
		_session,
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
	var storage_objects: NakamaAPI.ApiStorageObjects =  await _client.read_storage_objects_async(
		_session, 
		[NakamaStorageObjectId.new("playerData", "playerInfo", _session.user_id)]
	)
	
	if storage_objects.objects:
		var decodedObject = JSON.parse_string(storage_objects.objects[0].value) 
		return decodedObject
	
	return null


func updateUserInfoInDBasync(keyToUpdate, value):
	var currentUserInfo = await Server.getUserInfoInDBasync()
	
	if currentUserInfo.has(keyToUpdate):
		var existing_value = currentUserInfo[keyToUpdate]
		
		if typeof(existing_value) == TYPE_FLOAT or typeof(existing_value) == TYPE_INT:
			# If it's a float or int, add or subtract the value
			currentUserInfo[keyToUpdate] += value
		elif typeof(existing_value) == TYPE_ARRAY:
			# If it's an array, handle JSON objects within the array
			for entry in value:
				var found = false
				# Loop over the items in DB, but no way to add multiple items from arg yet
				for item in existing_value:
					var keysInValue = entry.keys()
					if item.has(keysInValue[0]):
						item[keysInValue[0]] += entry[keysInValue[0]]
						found = true
						break
				if not found:
					existing_value.append(entry)
	else:
		# If the key does not exist, initialize it appropriately
		if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
			currentUserInfo[keyToUpdate] = value
		elif typeof(value) == TYPE_ARRAY:
			currentUserInfo[keyToUpdate] = [value]

	#print_debug(currentUserInfo)
	# Optionally, update the server with the new user info if needed
	await _client.write_storage_objects_async(
		_session,
		[
			NakamaWriteStorageObject.new(
				"playerData",
				"playerInfo",
				ReadPermissions.OWNER_READ,
				WritePermissions.OWNER_WRITE,
				JSON.stringify(currentUserInfo),
				""
			)
		]
	)

# --------------------------------------------------------
# MULTIPLAYER RELATED
func connectSocketToServerAsync() -> int:
	_socket = Nakama.create_socket_from(_client)
	var result: NakamaAsyncResult = await _socket.connect_async(_session)
	
	if not result.is_exception():
		_socket.connect("closed", Callable(self, "_on_NakamaSocket_closed"))
		#_socket.connect("received_match_presence", Callable(self, "_on_NakamaSocket_received_match_presence"))
		
		return OK
		
	return ERR_CANT_CONNECT

func _on_NakamaSocket_closed():
	_socket = null

# TEST
func joinMatch(matchId):
	# THIS ONLY WORKS IF THERE IS A CREATED ROOM, ELSE IT WONT WORK
	# THE SERVER-SIDE MUST CREATE A MATCH OR IMPLEMENT A CLIENT-SIDE
	# FUNCTION TO DO THIS
	var match_id = "matchId"
	var joined_match = await _socket.join_match_async(match_id)

	if joined_match.is_exception():
		print("An error occurred: %s" % joined_match)
		return

	for presence in joined_match.presences:
		print("User id %s name %s'." % [presence.user_id, presence.username])
