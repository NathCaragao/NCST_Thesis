extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed : float

func _ready() -> void:
	visible = false


func _process(delta: float) -> void:
	flip_sprite()
	animation()



func rabbit_appear() -> void:
	visible = true
	animated_sprite.play("rabbit-jump")

func rabbit_hide() -> void:
	animated_sprite.play("rabbit-jump")
	visible = false

func flip_sprite() -> void:
	if velocity.x < 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true


func animation() -> void:
	if velocity.x > 0:
		animated_sprite.play("rabbit-run")
	elif velocity.x == 0:
		pass
