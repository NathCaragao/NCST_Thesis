class_name EnemyWolf
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp
@onready var hurt_box_shape: CollisionShape2D = $EnemyHealthComp/Hurtbox/CollisionShape2D

signal QuestQuota

# wolf stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400


func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_dead_quota"))

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "wolf-run",
	"enemy-attack" : "wolf-attack",
	"enemy-idle" : "wolf-idle",
	"enemy-hit" : "wolf-hit",
	"enemy-dead" : "wolf-dead"
}


# flip sprite
func flip_sprite() -> void:
	if velocity.x < 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -28
	else:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 28

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])

func on_dead_quota() -> void:
	emit_signal("QuestQuota")
