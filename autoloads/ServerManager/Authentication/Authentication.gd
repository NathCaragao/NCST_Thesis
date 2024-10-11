class_name Authentication
extends Node

# Shouldn't do any side effects
# Should return a positive or negative value since this will be the basis
#	of ServerManager if they should return OK and FAILED respectively.

# Use inputs to return a NakamaSession
func loginWithEmailAndPassword(nakamaClient: NakamaClient, email: String, password: String) -> NakamaSession:
	var newSession = await nakamaClient.authenticate_email_async(email, password, null, false)
	if not newSession.is_exception():
		return newSession
	else: 
		return null

# Use inputs to return a NakamaSession
func registerEmailAndPassword(nakamaClient: NakamaClient, username: String, email: String, password: String) -> NakamaSession:
	var newSession = await nakamaClient.authenticate_email_async(email, password, null, true)
	if not newSession.is_exception():
		# Change the display_name of user
		var updateUserInfoResult: NakamaAsyncResult = await nakamaClient.update_account_async(newSession, null, username, null, null, null)
		return newSession
	else:
		return null

func isEmailAlreadyExisting(nakamaClient: NakamaClient, emailToCheck: String) -> bool:
	const testPassword: String = "9b143b5e-e79b-49d1-a3b0-5a89cae64594"
	var checkResult = await nakamaClient.authenticate_email_async(emailToCheck, testPassword, null, true)
	if checkResult.is_exception():
		# Means email is already in use
		return true
	else:
		# New account created, means email isn't in use therefore we need to delete this account 
		await nakamaClient.delete_account_async(checkResult)
		return false

# Use input to logout a user, should return operation's status when done
func logoutUser(nakamaClient: NakamaClient, nakamaSession: NakamaSession) -> int:
	await nakamaClient.session_logout_async(nakamaSession)
	return OK

# Return a boolean if a user is currently logged in
func isUserLoggedIn(nakamaSession: NakamaSession) -> bool:
	if nakamaSession == null:
		return false
	return true

# Return a currently logged in user's info, this is in JSON or Dictionary format
func getUserLoggedInInfo(nakamaClient: NakamaClient, nakamaSession: NakamaSession):
	var userInfo = await nakamaClient.get_account_async(nakamaSession)
	return userInfo
