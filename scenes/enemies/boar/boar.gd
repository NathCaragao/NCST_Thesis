class_name EnemyBoar
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box_shape: CollisionShape2D = $BodyCollision


var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "boar-run",
	"enemy-attack" : "boar-attack",
	"enemy-idle" : "",
	"enemy-hit" : "boar-hit",
	"enemy-dead" : "boar-death"
}

# flip sprite
func flip_sprite() -> void:
	if velocity.x < 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -33
	else:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 33

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])
