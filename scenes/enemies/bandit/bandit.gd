class_name EnemyBandit
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp
@onready var hurt_box_shape: CollisionShape2D = $EnemyHealthComp/Hurtbox/HurtboxShape

# stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

func _ready() -> void:
	pass

var animation_mapping = {
	"enemy-run" : "bandit-run",
	"enemy-attack" : "bandit-attack",
	"enemy-idle" : "bandit-idle",
	"enemy-hit" : "",
	"enemy-dead" : ""
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])


# flip sprite
func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
