extends CharacterBody2D


@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var body_collision: CollisionShape2D = $BodyCollision


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400


func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 48
	if velocity.x < 0:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -48


var animation_mapping = {
	"enemy-run" : "lion-run",
	"enemy-attack1" : "lion-attack1",
	"enemy-attack2" : "lion-attack2",
	"enemy-idle" : "lion-idle",
	"enemy-hit" : "lion-hit",
	"enemy-dead" : "lion-death"
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])
