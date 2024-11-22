class_name EnemyDragon
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "dragon-run",
	"enemy-attack" : "dragon-attack",
	"enemy-idle" : "dragon-idle",
	"enemy-hit" : "dragon-hit",
	"enemy-dead" : "dragon-death"
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])

# flip sprite
func flip_sprite() -> void:
	if velocity.x < 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox.scale.x = 1
	else:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox.scale.x = -1
		


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$EnemyHealthComp/CanvasLayer.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$EnemyHealthComp/CanvasLayer.visible = false

func post_dialog() -> void:
	Dialogic.start("S11_5_postbattle")
