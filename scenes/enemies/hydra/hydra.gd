extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# mapping animations for fsm
var animation_mapping = {
	"enemy-run" : "",
	"enemy-attack" : "hydra-attack",
	"enemy-idle" : "hydra-idle",
	"enemy-hit" : "hydra-hit",
	"enemy-dead" : "hydra-death"
}

func play_animation(animation_name: String) -> void:
	if animation_name in animation_mapping:
		animation_player.play(animation_mapping[animation_name])
