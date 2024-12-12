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




# flip sprite
func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
