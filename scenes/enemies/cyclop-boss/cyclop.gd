class_name Megalus
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var hurt_box_shape: CollisionShape2D = $CollisionShape2D as CollisionShape2D

signal OpenTrapdoor

# stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

func _process(delta: float):
	if animation_mapping["enemy-dead"]:
		emit_signal("OpenTrapdoor")

# flip sprite
func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 106
		$EnemyHealthComp/Hurtbox/CollisionShape2D.position.x = 9
	elif velocity.x < 0:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -106
		$EnemyHealthComp/Hurtbox/CollisionShape2D.position.x = -9

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "cyclop-run",
	"enemy-attack" : "cyclop-attack",
	"enemy-idle" : "cyclop-idle",
	"enemy-hit" : "cyclop-hit",
	"enemy-dead" : "cyclop-death"
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])
