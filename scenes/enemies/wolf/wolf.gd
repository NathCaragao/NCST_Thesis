class_name EnemyWolf
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box_shape: CollisionShape2D = $EnemyHealthComp/Hurtbox/HurtBoxShape
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp

signal QuestQuota

# wolf stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400


func _ready() -> void:
	enemy_health_comp.connect("EnemyDead", Callable(self, "on_dead_quota"))

# flip sprite
func flip_sprite() -> void:
	if velocity.x < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func on_dead_quota() -> void:
	emit_signal("QuestQuota")
