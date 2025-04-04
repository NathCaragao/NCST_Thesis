extends Node2D
@export_category("UI Screens")
@export var settings_window : Control
@export var almanac_window : Control
@export var shop_window : Control
@export var inv_window : Control
@export var character_window : Control
@export var lobby_tutorial : Control
var isLoading = true
func _ready() -> void:
	ScoreUi.get_node('CanvasLayer').hide()
	QuestUi.get_node('CanvasLayer').hide()
	SceneManager.showLoadingScreen()
	var userStorageData = await ServerManager.getUserInfoInDBasync()
	var userAccountData = await ServerManager.getUserLoggedInInfo()
	setAccountName(userAccountData.user.display_name)
	setFreeCurrency(userStorageData["freeCurrency"])
	setPremiumCurrency(userStorageData["premiumCurrency"])
	setAttackLevel(userStorageData["upgrades"]["attack"])
	setHealthLevel(userStorageData["upgrades"]["health"])
	setDefenseLevel(userStorageData["upgrades"]["defense"])
	setSpeedLevel(userStorageData["upgrades"]["speed"])
	SceneManager.hideLoadingScreen()
	run_lobby_tutorial()
var timer: float = 0.0
func _process(delta: float) -> void:
	pass
func _on_shop_btn_pressed() -> void:
	shop_open()
func _on_play_btn_pressed() -> void:
	LevelScreenTransition.transition()
	await LevelScreenTransition.on_transition_finished
	SceneManager.changeScene("res://scenes/ui-scenes/game-mode-screen/game_mode_screen.tscn")
func _on_settings_btn_pressed() -> void:
	settings_open()
func _on_alamanac_btn_pressed() -> void:
	almanac_open()
func almanac_open() -> void:
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	almanac_window.position.y = screen_size.y
	tween.tween_property(almanac_window, "position:y", screen_size.y / 2 - almanac_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)
func settings_open() -> void:
	settings_window.visible = true
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	settings_window.position.y = screen_size.y
	tween.tween_property(settings_window, "position:y", screen_size.y / 2 - settings_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
func shop_open() -> void:
	shop_window.visible = true
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	shop_window.position.y = screen_size.y
	tween.tween_property(shop_window, "position:y", screen_size.y / 2 - shop_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
func _on_inv_btn_pressed() -> void:
	inventory_open()
func _on_chara_btn_pressed() -> void:
	PlayerManager.character_info = true
	character_info_open()
func inventory_open() -> void:
	inv_window.visible = true
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	inv_window.position.y = screen_size.y
	tween.tween_property(inv_window, "position:y", screen_size.y / 2 - inv_window.size.y / 2, 0.3) \
		.set_trans(Tween.TRANS_BACK)
func character_info_open() -> void:
	character_window.visible = true
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	character_window.position.y = screen_size.y
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
func setLobbyTutorial(newBoolValue : bool) -> void:
	PlayerManager.lobby_tutorial_played = newBoolValue
func run_lobby_tutorial() -> void:
	await get_tree().create_timer(1).timeout
	if !PlayerManager.lobby_tutorial_played:
		open_lobby_tutorial()
		lobby_tutorial.visible = true
		lobby_tutorial.update_tutorial_text()
func open_lobby_tutorial() -> void:
	lobby_tutorial.visible = true
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	lobby_tutorial.position.x = -screen_size.x
	tween.tween_property(lobby_tutorial, "position:x", 215, 0.3) \
		.set_trans(Tween.TRANS_BACK)
func close_lobby_tutorial() -> void:
	var tween = create_tween()
	var screen_size = get_viewport_rect().size
	tween.tween_property(lobby_tutorial, "position:x", -1192, 0.3) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): lobby_tutorial.visible = false)
func _on_tutorial_text_next_tutorial() -> void:
	await get_tree().create_timer(0.5).timeout
	close_lobby_tutorial()
	PlayerManager.lobby_tutorial_played = true
