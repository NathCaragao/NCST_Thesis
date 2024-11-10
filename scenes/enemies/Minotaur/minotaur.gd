extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var hurt_box_shape: CollisionShape2D = $BodyCollision as CollisionShape2D
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 300

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "minotaur-run",
	"enemy-attack" : "minotaur-attack",
	"enemy-idle" : "minotaur-idle",
	"enemy-hit" : "minotaur-hit",
	"enemy-dead" : "minotaur-death"
}

func flip_sprite() -> void:
	if velocity.x < 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -19.5
	else:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 19.5

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])
