class_name Megalus
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var hurt_box_shape: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@export var cyclop_hp_comp: EnemyHealthComp

signal OpenTrapdoor

# stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

func _process(delta: float) -> void:
	on_cyclop_death()

func on_cyclop_death() -> void:
	if cyclop_hp_comp.current_health == 0:
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


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	$EnemyHealthComp/CanvasLayer/EnemyHPbar.visible = true
	$EnemyHealthComp/CanvasLayer/Label.visible = true


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	$EnemyHealthComp/CanvasLayer/EnemyHPbar.visible = false
	$EnemyHealthComp/CanvasLayer/Label.visible = false
