extends Node

func loginWithEmailAndPassword(client : NakamaClient, email: String, password: String) -> NakamaSession:
	var session = await client.authenticate_email_async(email, password, null, false)
	if not session.is_exception():
		return session
	else: 
		return null

func registerWithEmailAndPass(client: NakamaClient, username: String, email: String, password: String):
	var session = await client.authenticate_email_async(email, password, null, true)
	if not session.is_exception():
		# Change the displayname of user
		var update : NakamaAsyncResult = await client.update_account_async(session, null, username, null, null, null)
		return session
	else:
		return null


#func loginWithGoogle():
	#pass
#
#func logoutUser():
	#await Server._client.session_logout_async(Server._session)
	#_session = null
	#_socket = null
