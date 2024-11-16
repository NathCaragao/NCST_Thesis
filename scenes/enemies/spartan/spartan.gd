class_name EnemySpartan
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp
@onready var hurtbox_area: CollisionShape2D = $EnemyHealthComp/Hurtbox/HurtboxArea

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

func _ready() -> void:
	pass

var animation_mapping = {
	"enemy-run" : "spartan-run",
	"enemy-attack" : "spartan-attack",
	"enemy-idle" : "spartan-idle",
	"enemy-hit" : "spartan-hit",
	"enemy-dead" : "spartan-death"
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])

func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/HitboxArea.position.x = 16
		$EnemyHealthComp/Hurtbox.scale.x = 1
		$BodyCollision.position.x = 7
	if velocity.x < 0:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/HitboxArea.position.x = -16
		$EnemyHealthComp/Hurtbox.scale.x = -1
		$BodyCollision.position.x = -7
