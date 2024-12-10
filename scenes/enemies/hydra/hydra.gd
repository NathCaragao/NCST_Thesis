class_name EnemyHydra
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal HydraDefeated

func _ready() -> void:
	pass

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "hydra-run",
	"enemy-attack" : "hydra-attack",
	"enemy-idle" : "hydra-idle",
	"enemy-hit" : "hydra-hit",
	"enemy-dead" : "hydra-death"
}

func _physics_process(delta: float) -> void:
	$PoisonPos.scale.x = -1

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])

func flip_sprite() -> void:
	if velocity.x < 0:
		sprite.flip_h = false
		$PoisonPos.scale.x = 1
	else:
		sprite.flip_h = true

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	$EnemyHealthComp/CanvasLayer.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	$EnemyHealthComp/CanvasLayer.visible = false

func post_dialog() -> void:
	Dialogic.start("S2_2-20")
	print("Current dialog playing: S2_2-20")
	QuestUi.transition_quest_box()
	
	QuestUi.add_quest("Lernaean Hydra", "Labor Complete!")
	
	await Dialogic.timeline_ended
	# Then wait 1.5 seconds
	await get_tree().create_timer(1.5).timeout
	emit_signal("HydraDefeated")
	print("signal emited")
