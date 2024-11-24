class_name BanditLeader
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp
@onready var hurt_box_shape: CollisionShape2D = $EnemyHealthComp/Hurtbox/CollisionShape2D

signal QuestQuota

# bandit stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400


# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "bandit-leader-run",
	"enemy-attack" : "bandit-leader-attack",
	"enemy-idle" : "bandit-leader-idle",
	"enemy-hit" : "bandit-leader-hit",
	"enemy-dead" : "bandit-leader-death"
}

# flip sprite
func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 17
	elif velocity.x < 0:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -17



func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])
