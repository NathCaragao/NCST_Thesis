extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func gate_open() -> void:
	animated_sprite.play("s3-gate1-open")
	await animated_sprite.animation_finished
	$StaticBody2D/CollisionShape2D.disabled = true
	print("S3_gate_1 OPENING>>>")
