extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_health_comp: EnemyHealthComp = $EnemyHealthComp

# stats
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

signal CalydonianBossBoarDefeated

func _ready() -> void:
	pass

var animation_mapping = {
	"enemy-run" : "boss-boar-run",
	"enemy-attack" : "boss-boar-attack",
	"enemy-idle" : "boss-boar-idle",
	"enemy-hit" : "boss-boar-hit",
	"enemy-dead" : "boss-boar-death"
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])

# flip sprite
func flip_sprite() -> void:
	if velocity.x < 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -33
	else:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 33

func boss_boar_defeated() -> void:
	QuestUi.transition_quest_box()
	QuestUi.add_quest("4th Labor", "Mission Complete")
	emit_signal("BossBoarDefeated")
func post_dialog() -> void:
	Dialogic.start("S1_A_4")
