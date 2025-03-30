class_name Authentication
extends Node
func loginWithEmailAndPassword(nakamaClient: NakamaClient, email: String, password: String) -> NakamaSession:
	var newSession = await nakamaClient.authenticate_email_async(email, password, null, false)
	if not newSession.is_exception():
		return newSession
	else: 
		return null
func registerEmailAndPassword(nakamaClient: NakamaClient, username: String, email: String, password: String) -> NakamaSession:
	var newSession = await nakamaClient.authenticate_email_async(email, password, null, true)
	if not newSession.is_exception():
		var updateUserInfoResult: NakamaAsyncResult = await nakamaClient.update_account_async(newSession, null, username, null, null, null)
		return newSession
	else:
		return null
func isEmailAlreadyExisting(nakamaClient: NakamaClient, emailToCheck: String) -> bool:
	const testPassword: String = "9b143b5e-e79b-49d1-a3b0-5a89cae64594"
	var checkResult = await nakamaClient.authenticate_email_async(emailToCheck, testPassword, null, true)
	if checkResult.is_exception():
		return true
	else:
		await nakamaClient.delete_account_async(checkResult)
		return false
func logoutUser(nakamaClient: NakamaClient, nakamaSession: NakamaSession) -> int:
	await nakamaClient.session_logout_async(nakamaSession)
	return OK
func isUserLoggedIn(nakamaSession: NakamaSession) -> bool:
	if nakamaSession == null:
		return false
	return true
func getUserLoggedInInfo(nakamaClient: NakamaClient, nakamaSession: NakamaSession):
	var userInfo = await nakamaClient.get_account_async(nakamaSession)
	return userInfo