class_name PlayerAtalanta
extends CharacterBody2D



# FINAL VARIABLES
# -- Updated and used for server-client comm
# THIS IS ALREADY SETUP FOR DEFAULT VALUES
var playerGameData = {
	"playerId" = "",
	"displayName" = "",
	"isControlled" = true,
	"isJumping" = false,
	"isAttacking" = false,
	"isSkill" = false,
	"direction" = 0,
	"weaponMode" = "Melee",
	"velocity" = Vector2(0, 0),
	"position" = Vector2(0, 0),
}

# -- One time setup
var move_speed: float
var defense : float = 5.0
var base_dmg : float = 10.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var push = 40
@export var SPEED: float = 200.0

var facing_right: bool = true
# player inventory reference
@export var inv: Inventory

@export var player_hp : PlayerHpComp
@export var hurtbox_collision : CollisionShape2D

# Signals
signal PlayerFail

func _ready() -> void:
	# initialize player stats on PlayerManager Autoload
	move_speed = PlayerManager.player_move_speed
	defense = PlayerManager.player_defense

func initialize(initSpawnPosition, initIsControlled: bool, initPlayerId: String = "", initDisplayName: String = ""):
	self.playerGameData.playerId = initPlayerId
	self.playerGameData.displayName = initDisplayName
	self.playerGameData.isControlled = initIsControlled
	self.position = initSpawnPosition
	self.playerGameData.position = initSpawnPosition
	#%Camera2D.enabled = self.playerGameData.isControlled
	if self.playerGameData.isControlled:
		%NameTag.hide()
		$"Arrow-down".show()
	else:
		$"Arrow-down".hide()
		%NameTag.show()
		%NameTag.text = self.playerGameData.displayName

# ONLY CALLED IF THE PLAYER IS NOT BEING CONTROLLED (PRIMARILY USED TO ONLY SUPPLY VARIABLE UPDATES)
func updatePlayer(updateDictionary):
	self.playerGameData.isJumping = updateDictionary["ongoingMatchData"]["isJumping"]
	self.playerGameData.isAttacking = updateDictionary["ongoingMatchData"]["isAttacking"]
	self.playerGameData.direction = updateDictionary["ongoingMatchData"]["direction"]
	self.playerGameData.isSkill = updateDictionary["ongoingMatchData"]["isSkill"]
	self.playerGameData.weaponMode = updateDictionary["ongoingMatchData"]["weaponMode"]
	
	self.playerGameData.velocity = _string_to_vector2(updateDictionary["ongoingMatchData"]["velocity"])
	self.playerGameData.position = _string_to_vector2(updateDictionary["ongoingMatchData"]["position"])
	self.position = self.playerGameData.position

func _string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(int(array[0]), int(array[1]))
	return Vector2.ZERO

# STEP 1: IF CONTROLLED, INPUTS SHOULD BE CAPTURED
# STEP 2: PLAYERGAMEDATA IS TO BE UPDATED WITH THE VALUES GOTTEN FROM INPUTS
# STEP 3: THINGS ARE TO BE UPDATED SINCE PLAYERGAMEDATA HAS CHANGED
# STEP 4: PLAYERGAMEDATA IS SENT TO THE SERVER - DONE EXTERNALLY
func _physics_process(delta: float) -> void:
	#%State.text = "Skill CD: %s" % str(ceil($StateMachine/PlayerSkill.skillCooldown))
	
	if self.playerGameData.isControlled:
		# Horizontal Movement
		self.playerGameData.direction = Input.get_axis("move_left", "move_right")
		# Capture jumping
		self.playerGameData.isJumping = Input.is_action_just_pressed("jump")
		# Capture attack usage
		self.playerGameData.isAttacking = Input.is_action_just_pressed("attack")
		# Capture skill usage
		self.playerGameData.isSkill = Input.is_action_just_pressed("skill")
		
		# Velocity update even if there is no input directly affecting this
		self.playerGameData.velocity = self.velocity
		self.playerGameData.position = self.position
		
		_flip_sprite()


func _flip_sprite() -> void:
	if self.playerGameData.direction > 0:
		sprite.flip_h = false
		# put other hitboxes here
	if self.playerGameData.direction < 0:
		sprite.flip_h = true
		# put other hitboxes here
	
	if self.playerGameData.direction == 1:
		$ArrowPos.scale.x = 1
		$PlayerHealthComponent/Hurtbox.scale.x = 1
	elif self.playerGameData.direction == -1:
		$PlayerHealthComponent/Hurtbox.scale.x = -1
		$ArrowPos.scale.x = -1

# collect items
func collect(item):
	inv.insert(item)

func apply_item_effect(item):
	match item["effect"]:
		"Health_Potion":
			var heal_amount: int = 30
			player_hp.current_health += heal_amount
			# update health bar UI
			player_hp.phealth_bar.health = player_hp.current_health
			# some debug text
			EventNotifier.add_notif("Healed +30 HP")
		"speed_buff":
			var speed_amount: float = 30.0
			move_speed += speed_amount
			EventNotifier.add_notif("Speed buff activated + 30")
			await get_tree().create_timer(15).timeout
			move_speed -= speed_amount
			EventNotifier.add_notif("Speed buff expired.")
		"atk_boost":
			var atk_amount : float = 15.0
			#arrow_hitbox.total_dmg += atk_amount
			EventNotifier.add_notif("Attack buff activated + 15")
			await get_tree().create_timer(15).timeout
			#arrow_hitbox.total_dmg -= atk_amount
			EventNotifier.add_notif("Attack buff expired.")
		"defense_buff":
			var def_amount : float = 15.0
			defense += def_amount
			EventNotifier.add_notif("Defense buff activated + 15")
			await get_tree().create_timer(10).timeout
			defense -= def_amount
			EventNotifier.add_notif("Defense buff expired.")

func player_fail() -> void:
	if player_hp.current_health == 0:
		emit_signal("PlayerFail")
