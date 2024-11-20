extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp

# stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : int = 30

func _ready() -> void:
	pass

var animation_mapping = {
	"enemy-run" : "bird-run",
	"enemy-attack" : "bird-attack",
	"enemy-idle" : "bird-idle",
	"enemy-hit" : "bird-hit",
	"enemy-dead" : "bird-death"
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])

func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 27
	if velocity.x < 0:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -27
