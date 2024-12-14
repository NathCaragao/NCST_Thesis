extends Control

const shopLocalServerURL = "http://localhost:5173"
const shopCloudServerURL = "https://5173-nathcaragao-nakamaserve-wqsrj0o3ahe.ws-us117.gitpod.io"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_buy_btn_1_pressed() -> void:
	var user = await ServerManager.getUserLoggedInInfo()
	var userId = user.user.id
	print_debug(userId)
	OS.shell_open("%s/buy/gem/60/%s" % [shopCloudServerURL, userId])


func _on_buy_btn_2_pressed() -> void:
	var user = await ServerManager.getUserLoggedInInfo()
	var userId = user.user.id
	print_debug(userId)
	OS.shell_open("http://localhost:5173/buy/gem/200/%s" % userId)


func _on_buy_btn_4_pressed() -> void:
	var user = await ServerManager.getUserLoggedInInfo()
	var userId = user.user.id
	print_debug(userId)
	OS.shell_open("http://localhost:5173/buy/gem/700/%s" % userId)


func _on_buy_btn_5_pressed() -> void:
	var user = await ServerManager.getUserLoggedInInfo()
	var userId = user.user.id
	print_debug(userId)
	OS.shell_open("http://localhost:5173/buy/gem/900/%s" % userId)
