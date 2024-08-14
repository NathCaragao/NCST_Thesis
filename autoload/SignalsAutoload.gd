extends Node

# ServerManager related signals
#	- Auth
signal requestEmailAndPassLogin(email : String, password : String)

# SceneManager related signals
#	- SceneManager, should be another children not SceneManager itself
signal requestChangeScene(nameOfScene : Enums.Scenes)
#	- Notification
signal requestDisplayNotification(notificationMessage : String)
