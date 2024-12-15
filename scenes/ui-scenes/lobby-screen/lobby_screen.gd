extends Node2D

# FLOW OF GUI:
# 1. Show loading screen first
# 2. Update labels: Account Name, Free and Premium Currency
# 3. Remove loading screen

# references
@export_category("UI Screens")
@export var settings_window : Control
@export var almanac_window : Control
@export var shop_window : Control
@export var inv_window : Control
@export var character_window : Control
@export var lobby_tutorial : Control

var isLoading = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()
	QuestUi.get_node('CanvasLayer').hide()
	# 1
	SceneManager.showLoadingScreen()
	# 2
	var userStorageData = await ServerManager.getUserInfoInDBasync()
	var userAccountData = await ServerManager.getUserLoggedInInfo()
	setAccountName(userAccountData.user.display_name)
	setFreeCurrency(userStorageData["freeCurrency"])
	setPremiumCurrency(userStorageData["premiumCurrency"])
	setAttackLevel(userStorageData["upgrades"]["attack"])
	setHealthLevel(userStorageData["upgrades"]["health"])
	setDefenseLevel(userStorageData["upgrades"]["defense"])
	setSpeedLevel(userStorageData["upgrades"]["speed"])
	# 3
	SceneManager.hideLoadingScreen()
	
	run_lobby_tutorial()
	
var timer: float = 0.0
func _process(delta: float) -> void:
	pass
	#timer += delta
	#if timer >= 10.0:
		#var userStorageData = await ServerManager.getUserInfoInDBasync()
		#setFreeCurrency(userStorageData["freeCurrency"])
		#setPremiumCurrency(userStorageData["premiumCurrency"])
		#timer = 0

# shop button
func _on_shop_btn_pressed() -> void:
	shop_open()

# play button
func _on_play_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	
	SceneManager.changeScene("res://scenes/ui-scenes/game-mode-screen/game_mode_screen.tscn")

# settings button
func _on_settings_btn_pressed() -> void:
	# press to open and close
	settings_open()

func _on_alamanac_btn_pressed() -> void:
	almanac_open()

func almanac_open() -> void:
	almanac_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	almanac_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(almanac_window, "position:y", screen_size.y / 2 - almanac_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)

func settings_open() -> void:
	settings_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	settings_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(settings_window, "position:y", screen_size.y / 2 - settings_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)

func shop_open() -> void:
	shop_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	shop_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(shop_window, "position:y", screen_size.y / 2 - shop_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)


func _on_inv_btn_pressed() -> void:
	inventory_open()


func _on_chara_btn_pressed() -> void:
	PlayerManager.character_info = true
	character_info_open()


func inventory_open() -> void:
	inv_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	inv_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(inv_window, "position:y", screen_size.y / 2 - inv_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)

func character_info_open() -> void:
	character_window.visible = true
	
	# create a tween
	var tween = create_tween()
	
	 # Set the initial position of the almanac window to below the screen
	var screen_size = get_viewport_rect().size
	character_window.position.y = screen_size.y
	# Animate the window moving from bottom to center
	tween.tween_property(character_window, "position:y", screen_size.y / 2 - character_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)


func setAccountName(newAccountName: String) -> void:
	%AccountName.text = newAccountName

func setFreeCurrency(newFreeCurrency: int) -> void:
	%OfflineCurrency2.text = "%s" % newFreeCurrency
	PlayerManager.coins = newFreeCurrency
	print_debug("coints in player_manager: %s" % PlayerManager.coins)

func setPremiumCurrency(newPremiumCurrency: int) -> void:
	%PrCurrency.text = "%s" % newPremiumCurrency
	PlayerManager.gems = newPremiumCurrency

func setAttackLevel(newAttackLevel: int) -> void:
	PlayerManager.attackUpgradeLevel = newAttackLevel
	
func setHealthLevel(newHealthLevel: int) -> void:
	PlayerManager.healthUpgradeLevel = newHealthLevel
	
func setDefenseLevel(newDefenseLevel: int) -> void:
	PlayerManager.defenseUpgradeLevel = newDefenseLevel
	
func setSpeedLevel(newSpeedLevel: int) -> void:
	PlayerManager.speedUpgradeLevel = newSpeedLevel

# new variables to setup in the PLAYER'S ACCOUNT
func setLobbyTutorial(newBoolValue : bool) -> void:
	PlayerManager.lobby_tutorial_played = newBoolValue

func run_lobby_tutorial() -> void:
	# put buffer
	await get_tree().create_timer(1).timeout
	# display tutorial
	if !PlayerManager.lobby_tutorial_played:
		open_lobby_tutorial()
		lobby_tutorial.visible = true
		lobby_tutorial.update_tutorial_text()

func open_lobby_tutorial() -> void:
	lobby_tutorial.visible = true
	
	# Create a tween
	var tween = create_tween()
	
	# Set the initial position of the inventory window off-screen to the right
	var screen_size = get_viewport_rect().size
	lobby_tutorial.position.x = -screen_size.x
	
	# Animate the window moving from the right to the center
	tween.tween_property(lobby_tutorial, "position:x", 215, 0.3) \
		.set_trans(Tween.TRANS_BACK)

func close_lobby_tutorial() -> void:
	# Create a tween
	var tween = create_tween()
	
	# Set the initial position of the inventory window off-screen to the right
	var screen_size = get_viewport_rect().size
	
	# Animate the window moving from the right to the center
	tween.tween_property(lobby_tutorial, "position:x", -1192, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	
	# After the animation completes, hide the window
	tween.tween_callback(func(): lobby_tutorial.visible = false)


func _on_tutorial_text_next_tutorial() -> void:
	await get_tree().create_timer(0.5).timeout
	close_lobby_tutorial()
	# set the player played lobby tutorial boolean to true
	# to prevent from playing again
	PlayerManager.lobby_tutorial_played = true
