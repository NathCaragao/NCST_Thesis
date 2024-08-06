extends Node

@export var serverManager : Node = null

#
#func handleRequestEmailAndPassLogin(email: String, password: String):
	#_session = await _client.authenticate_email_async(email, password, null, false)
	#if not _session.is_exception():
		#return OK
	#else: 
		#return null
	#
#func handleRequestEmailAndPassRegister(username: String, email: String, password: String):
	#_session = await _client.authenticate_email_async(email, password, null, true)
	#if not _session.is_exception():
		## Change the displayname of user
		#var update : NakamaAsyncResult = await _client.update_account_async(_session, null,username, null, null, null)
		#return OK
	#else:
		#return null
	#
#
#func loginWithGoogle():
	#pass
#
#func logoutUser():
	#await Server._client.session_logout_async(Server._session)
	#_session = null
	#_socket = null
