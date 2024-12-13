class_name ArrowHitbox
extends Node2D

@export var speed : float = 500.0
@export var attack_component: AttackComponent
@onready var arrow_col: CollisionShape2D = $ProjectileHitbox/ArrowCol


var vel : float
var total_dmg : int
var has_hit : bool = false

func _physics_process(delta: float) -> void:
	move_local_x(vel * speed * delta)

func _ready() -> void:
	pass

func flip_sprite(isFlip: bool) -> void:
	if isFlip:
		%Sprite2D.flip_h = true
	

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
