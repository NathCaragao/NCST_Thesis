class_name PlayerHercules
extends CharacterBody2D


# FINAL VARIABLES
# -- Updated and used for server-client comm
var playerId: String = ""
var isControlled: bool = false
var isJumping: bool = false
var isAttacking: bool = false
var isSkill: bool = false
var direction = 1  # 1 being facing right
var weaponMode = "Melee"

# -- One time setup
@export var move_speed: float = 200.0
var weapon_mode : String = "Melee" # Will be USED FOR S-C COMM
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var inv : Inventory
@onready var player_hp: PlayerHpComp = $PlayerHealthComponent

# Signals
signal PlayerFail

func _ready() -> void:
	initialize("", true)


func initialize(initPlayerId: String, initIsControlled: bool):
	self.playerId = initPlayerId
	self.isControlled = initIsControlled
	%Camera2D.enabled = self.isControlled

# ONLY CALLED IF THE PLAYER IS NOT BEING CONTROLLED (PRIMARILY USED TO ONLY SUPPLY VARIABLE UPDATES)
func updatePlayer(updateDictionary):
	self.isJumping = updateDictionary["isJumping"]
	self.isAttacking = updateDictionary["isAttacking"]
	self.direction = updateDictionary["direction"]
	self.isSkill = updateDictionary["isSkill"]


# SHOULD HANDLE INPUTS TO CHANGE VARIABLES GOING TO BE SENT TO SERVER
func _input(event: InputEvent) -> void:
	if !self.isControlled:
		return
	
	# Horizontal Movement
	self.direction = Input.get_axis("move_left", "move_right")
	# Capture jumping
	self.isJumping = Input.is_action_just_pressed("jump")
	# Capture skill usage
	self.isSkill = Input.is_action_just_pressed("skill")
	# Weapon Mode switching
	if event.is_action_pressed("melee-mode"):
		self.weaponMode = "Melee"
		switch_weapon_mode("Melee")
	elif event.is_action_pressed("ranged-mode"):
		self.weaponMode = "Ranged"
		switch_weapon_mode("Ranged")
	

func _physics_process(delta: float) -> void:
	_flip_sprite()

func _flip_sprite() -> void:
	if direction > 0:
		sprite.flip_h = false
		$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = 19
		$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = 27.75
	if direction < 0:
		sprite.flip_h = true
		$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = -19
		$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = -27.75
	
	if direction == 1:
		$ArrowPos.scale.x = 1
	elif direction == -1:
		$ArrowPos.scale.x = -1

# function for pushing objects such as boxes
#func push_objects() -> void:
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody2D:
			#c.get_collider().apply_central_impulse(-c.get_normal() * (push + SPEED))

func switch_weapon_mode(mode) -> void:
	if mode == "Melee":
		weapon_mode = "Melee"
		print("Mode: ", weapon_mode) # replace with fancy UI
	elif mode == "Ranged":
		weapon_mode = "Ranged"
		print("Mode: ", weapon_mode) # replace with fancy UI

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
