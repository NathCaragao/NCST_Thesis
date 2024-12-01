class_name PlayerHercules
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

@export var push = 40
@export var SPEED: float = 200.0
@export var weapon_ui : Control
var facing_right : bool = true

# variables for switching weapon class
var weapon_mode : String = "Melee" # default weapon mode
var direction

# player inventory reference
@export var inv : Inventory
@onready var player_hp: PlayerHpComp = $PlayerHealthComponent

# signals
signal PlayerFail


func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		facing_right = true
	elif velocity.x < 0:
		facing_right = false
	
	direction = Input.get_axis("move_left", "move_right")


# flip sprite
func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = 19
		$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = 27.75
	if velocity.x < 0:
		sprite.flip_h = true
		$PlayerHealthComponent/Hitbox/CollisionShape2D.position.x = -19
		$PlayerHealthComponent/SkillHitbox/CollisionShape2D.position.x = -27.75
	
	if direction == 1:
		$ArrowPos.scale.x = 1
		$PlayerHealthComponent/Hurtbox.scale.x = 1
	elif direction == -1:
		$PlayerHealthComponent/Hurtbox.scale.x = -1
		$ArrowPos.scale.x = -1

# function for pushing objects such as boxes
#func push_objects() -> void:
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody2D:
			#c.get_collider().apply_central_impulse(-c.get_normal() * (push + SPEED))

# weapon switching
func switch_weapon_mode(mode) -> void:
	if mode == "Melee":
		weapon_mode = "Melee"
	elif mode == "Ranged":
		weapon_mode = "Ranged"

# weapon input switching
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee-mode"):
		if weapon_mode != "Melee":
			weapon_ui.rotate_roulette(180)
			switch_weapon_mode("Melee")
	
	elif event.is_action_pressed("ranged-mode"):
		if weapon_mode != "Ranged":
			weapon_ui.rotate_roulette(180)
			switch_weapon_mode("Ranged")

# collect items
func collect(item):
	inv.insert(item)

# apply effect function
func apply_item_effect(item):
	match item["effect"]:
		"Health_Potion":
			var heal_amount : int = 30
			player_hp.current_health += heal_amount
			# update health bar UI
			player_hp.phealth_bar.health = player_hp.current_health
			# some debug text
			print("Player Healed! ", str(player_hp.current_health))
			EventNotifier.add_notif("Healed +30 HP")
		"atk_boost":
			var atk_amount : int = 20
			#atk += atk_amount
			#print("Player attack boosted: ", str(atk))

func player_fail() -> void:
	if player_hp.current_health == 0:
		emit_signal("PlayerFail")
