class_name PlayerHercules
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

@export var push = 40
@export var SPEED: float = 200.0


func _physics_process(delta: float) -> void:
	push_objects()




# flip sprite
func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		# hitbox here
		# skill hitbox here
	if velocity.x < 0:
		sprite.flip_h = true
		# hitbox here
		# skill hitbox here

# function for pushing objects such as boxes
func push_objects() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * (push + SPEED))
