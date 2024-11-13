extends Area2D
@onready var sprite_2d = $Sprite2D
@export var static_collision : StaticBody2D

func destroy_log() -> void:
	# put destory log animation here
	# disable collision in the animation track
	# queue free the whole log scene in the animation track
	sprite_2d.queue_free()
	$CollisionShape2D.queue_free()
	$StaticBody2D/CollisionShape2D.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Debris"):
		destroy_log()
