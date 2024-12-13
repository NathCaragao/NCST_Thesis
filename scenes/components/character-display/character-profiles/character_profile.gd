extends CharacterBody2D

@export var character_data: CharacterResource

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var health : float
var attack : float
var defense : float
var speed : float

func _ready() -> void:
	health += PlayerManager.player_health
	attack += PlayerManager.player_attack
	defense += PlayerManager.player_defense
	speed += PlayerManager.player_move_speed
	
	# set idle animation
	
	animated_sprite.sprite_frames = character_data.idle_anim
	animated_sprite.play("default")
