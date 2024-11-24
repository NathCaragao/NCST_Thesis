extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp as EnemyHealthComp
@onready var hurt_box_shape: CollisionShape2D = $EnemyHealthComp/Hurtbox/HurtboxShape

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 300

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "skeleton-run",
	"enemy-attack" : "skeleton-attack",
	"enemy-idle" : "skeleton-idle",
	"enemy-hit" : "skeleton-hit",
	"enemy-dead" : "skeleton-death"
}

func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/HitboxShape.position.x = 47.5
	if velocity.x < 0:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/HitboxShape.position.x = -47.5
		

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])
