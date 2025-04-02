class_name ProjectileHitbox
extends Area2D
@export var projectile_dmg : int = 20
var already_hit : bool = false
func _init() -> void:
	collision_layer = 2 
	collision_mask = 0
func on_collide() -> void:
	if already_hit == false:
		already_hit = true
		owner.queue_free()
	else:
		return
