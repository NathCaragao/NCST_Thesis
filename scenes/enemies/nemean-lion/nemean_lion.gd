extends CharacterBody2D


@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var body_collision: CollisionShape2D = $BodyCollision
@onready var hurt_box_shape: CollisionShape2D = $EnemyHealthComp/Hurtbox/CollisionShape2D

@export var lion_hp_comp : Node2D

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var move_speed : float = 400

signal LionDefeated


func flip_sprite() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = 29
	if velocity.x < 0:
		sprite.flip_h = true
		$EnemyHealthComp/Hitbox/CollisionShape2D.position.x = -32


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

func lion_defeated() -> void:
	lion_dialog()

# when the lion is on the screen
func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	hp_bar_open()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	hp_bar_close()

func hp_bar_open() -> void:
	$EnemyHealthComp/HPUI/EnemyHPbar.visible = true
	$EnemyHealthComp/HPUI/Label.visible = true

func hp_bar_close() -> void:
	$EnemyHealthComp/HPUI/EnemyHPbar.visible = false
	$EnemyHealthComp/HPUI/Label.visible = false

func lion_dialog() -> void:
	Dialogic.start("S1_1-15-2")
	print("Current dialog playing: S1_1-15-2")
	# Wait for dialog to complete
	await Dialogic.timeline_ended
	
	QuestUi.transition_quest_box()
	QuestUi.add_quest("The First Labor", "Mission Complete!")
	
	# Then wait 1.5 seconds
	await get_tree().create_timer(1.5).timeout
	# Finally emit the victory signal
	emit_signal("LionDefeated")
