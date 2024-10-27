class_name PlayerHercules
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

@export var push = 40
@export var SPEED: float = 200.0
var facing_right : bool = true

# variables for switching weapon class
var weapon_mode : String = "Melee" # default weapon mode
var direction

# player inventory reference
@export var inv : Inventory

func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		facing_right = true
	elif velocity.x < 0:
		facing_right = false
	
	push_objects()
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
	elif direction == -1:
		$ArrowPos.scale.x = -1

# function for pushing objects such as boxes
func push_objects() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * (push + SPEED))

# weapon switching
func switch_weapon_mode(mode) -> void:
	if mode == "Melee":
		weapon_mode = "Melee"
		print("Mode: ", weapon_mode) # replace with fancy UI
	elif mode == "Ranged":
		weapon_mode = "Ranged"
		print("Mode: ", weapon_mode) # replace with fancy UI

# weapon input switching
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee-mode"):
		switch_weapon_mode("Melee")
	
	elif event.is_action_pressed("ranged-mode"):
		switch_weapon_mode("Ranged")

# collect items
func collect(item):
	inv.insert(item)

# apply effect function
func apply_item_effect(item):
	match item["effect"]:
		"Health_Potion":
			var heal_amount : int = 30
			#health += heal_amount
			#print("Player Healed! ", str(health))
		"atk_boost":
			var atk_amount : int = 20
			#atk += atk_amount
			#print("Player attack boosted: ", str(atk))
