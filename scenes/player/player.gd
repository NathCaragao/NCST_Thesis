class_name PlayerHercules
extends CharacterBody2D



	# How to decode velocity
	#print_debug(Vector2(self.playerGameData.velocity))
	
# FINAL VARIABLES
# -- Updated and used for server-client comm
var playerGameData = {
	"playerId" = "",
	"displayName" = "",
	"isControlled" = false,
	"isJumping" = false,
	"isAttacking" = false,
	"isSkill" = false,
	"direction" = 1,
	"weaponMode" = "Melee",
	"velocity" = Vector2(0, 0),
	"position" = Vector2(0, 0),
}

# -- One time setup
@export var move_speed: float = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var inv : Inventory
@onready var player_hp: PlayerHpComp = $PlayerHealthComponent

# Signals
signal PlayerFail

func _ready() -> void:
	initialize(self.position, false, "", "NOTTTTTTTTTTTTTTTT")
	pass


func initialize(initSpawnPosition, initIsControlled: bool, initPlayerId: String = "", initDisplayName: String = ""):
	self.playerGameData.playerId = initPlayerId
	self.playerGameData.displayName = initDisplayName
	self.playerGameData.isControlled = initIsControlled
	self.position = initSpawnPosition
	self.playerGameData.position = initSpawnPosition
	%Camera2D.enabled = self.playerGameData.isControlled
	if self.playerGameData.isControlled:
		%NameTag.hide()
	else:
		%NameTag.text = self.playerGameData.displayName
		%NameTag.show()

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

func _input(event: InputEvent) -> void:
	pass
	#if !self.playerGameData.isControlled:
		#return
	#
	## Horizontal Movement
	#self.playerGameData.direction = Input.get_axis("move_left", "move_right")
	## Capture jumping
	#self.playerGameData.isJumping = Input.is_action_just_pressed("jump")
	## Capture attack usage
	#self.playerGameData.isAttacking = Input.is_action_just_pressed("attack")
	## Capture skill usage
	#self.playerGameData.isSkill = Input.is_action_just_pressed("skill")
	## Weapon Mode switching
	#if event.is_action_pressed("melee-mode"):
		#self.playerGameData.weaponMode = "Melee"
		#switch_weapon_mode("Melee")
	#elif event.is_action_pressed("ranged-mode"):
		#self.playerGameData.weaponMode = "Ranged"
		#switch_weapon_mode("Ranged")
	## Velocity update even if there is no input directly affecting this
	#self.playerGameData.velocity = self.velocity

# STEP 1: IF CONTROLLED, INPUTS SHOULD BE CAPTURED
# STEP 2: PLAYERGAMEDATA IS TO BE UPDATED WITH THE VALUES GOTTEN FROM INPUTS
# STEP 3: THINGS ARE TO BE UPDATED SINCE PLAYERGAMEDATA HAS CHANGED
# STEP 4: PLAYERGAMEDATA IS SENT TO THE SERVER - DONE EXTERNALLY
func _physics_process(delta: float) -> void:
	if self.playerGameData.isControlled:
		# Horizontal Movement
		self.playerGameData.direction = Input.get_axis("move_left", "move_right")
		# Capture jumping
		self.playerGameData.isJumping = Input.is_action_just_pressed("jump")
		# Capture attack usage
		self.playerGameData.isAttacking = Input.is_action_just_pressed("attack")
		# Capture skill usage
		self.playerGameData.isSkill = Input.is_action_just_pressed("skill")
		# Weapon Mode switching
		if Input.is_action_just_pressed("melee-mode"):
			self.playerGameData.weaponMode = "Melee"
			switch_weapon_mode("Melee")
		elif Input.is_action_just_pressed("ranged-mode"):
			self.playerGameData.weaponMode = "Ranged"
			switch_weapon_mode("Ranged")
		# Velocity update even if there is no input directly affecting this
		self.playerGameData.velocity = self.velocity
		self.playerGameData.position = self.position
	
	_flip_sprite()

func _flip_sprite() -> void:
	if self.playerGameData.direction > 0:
		sprite.flip_h = false
		$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = 19
		$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = 27.75
	if self.playerGameData.direction < 0:
		sprite.flip_h = true
		$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = -19
		$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = -27.75
	
	if self.playerGameData.direction == 1:
		$ArrowPos.scale.x = 1
	elif self.playerGameData.direction == -1:
		$ArrowPos.scale.x = -1

# function for pushing objects such as boxes
#func push_objects() -> void:
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody2D:
			#c.get_collider().apply_central_impulse(-c.get_normal() * (push + SPEED))

func switch_weapon_mode(mode) -> void:
	if mode == "Melee":
		self.playerGameData.weaponMode = "Melee"
		print("Mode: ", self.playerGameData.weaponMode) # replace with fancy UI
	elif mode == "Ranged":
		self.playerGameData.weaponMode = "Ranged"
		print("Mode: ", self.playerGameData.weaponMode) # replace with fancy UI

func collect(item):
	inv.insert(item)

func apply_item_effect(item):
	match item["effect"]:
		"Health_Potion":
			var heal_amount : int = 30
			player_hp.current_health += heal_amount
			# update health bar UI
			player_hp.phealth_bar.health = player_hp.current_health
			# some debug text
			print("Player Healed! ", str(player_hp.current_health))
		"atk_boost":
			var atk_amount : int = 20
			#atk += atk_amount
			#print("Player attack boosted: ", str(atk))

func player_fail() -> void:
	if player_hp.current_health == 0:
		emit_signal("PlayerFail")
